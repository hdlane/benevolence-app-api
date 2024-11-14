namespace :provider_thanks do
  desc "Send thank you email to all providers whose delivery date passed"
  task send_email: :environment do
    providers = Provider.left_joins(:delivery_dates, :person, :requests, :organization)
    .select("delivery_dates.date", "people.first_name as person_name",
            "people.email as person_email", "requests.title",
            "organizations.name as organization_name")
    .where("delivery_dates.date = ?", Date.yesterday)
    providers.each do |provider|
      PersonMailer.with(
        organization_name: provider[:organization_name],
        person_name: provider[:person_name],
        person_email: provider[:person_email],
        title: provider[:title],
      ).provider_thanks.deliver_later
    end
  end
end
