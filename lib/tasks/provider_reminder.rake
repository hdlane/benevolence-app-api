CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

namespace :provider_reminder do
  desc "Send email reminder to all providers that have a delivery date tomorrow"
  task send_email: :environment do
    providers = Provider.left_joins(:delivery_dates, :person, :resource, :requests)
    .select("delivery_dates.date", "people.first_name as person_name",
            "people.email as person_email", "resources.name as resource_name",
            "providers.quantity as resource_quantity",
            "requests.id as request_id", "requests.title")
    .where("delivery_dates.date = ?", Date.tomorrow)
    providers.each do |provider|
      PersonMailer.with(
        date: provider[:date],
        person_name: provider[:person_name],
        person_email: provider[:person_email],
        resource_name: provider[:resource_name],
        resource_quantity: provider[:resource_quantity],
        request_link: "#{CLIENT_DOMAIN}/requests/#{provider[:request_id]}",
        title: provider[:title],
      ).provider_reminder.deliver_later
    end
  end
end
