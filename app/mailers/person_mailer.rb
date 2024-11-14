class PersonMailer < ApplicationMailer
  def mail_login_link
    @person = params[:person]
    @url = params[:url]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Login to Benevolence App")
  end

  def organization_created
    @person = params[:person]
    @person_name = @person.first_name
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Your organization has been created")
  end

  def organization_deleted
    @person = params[:person]
    @person_name = @person.first_name
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Your organization has been deleted")
  end

  def provider_donation_service_assigned
    @date = params[:date]
    @end_time = params[:end_time]
    @person = params[:person]
    @person_name = @person.first_name
    @request_link = params[:request_link]
    @resource_name = params[:resource_name]
    @resource_quantity = params[:resource_quantity]
    @start_time = params[:start_time]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Thanks for signing up!")
  end

  def provider_meal_assigned
    @date = params[:date]
    @person = params[:person]
    @person_name = @person.first_name
    @request_link = params[:request_link]
    @resource_name = params[:resource_name]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Thanks for signing up!")
  end

  def provider_donation_service_updated
    @date = params[:date]
    @end_time = params[:end_time]
    @person = params[:person]
    @person_name = @person.first_name
    @request_link = params[:request_link]
    @resource_name = params[:resource_name]
    @resource_quantity = params[:resource_quantity]
    @start_time = params[:start_time]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Update to your assignment")
  end

  def provider_meal_updated
    @date = params[:date]
    @person = params[:person]
    @person_name = @person.first_name
    @request_link = params[:request_link]
    @resource_name = params[:resource_name]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Update to your assignment")
  end

  def provider_reminder
    @date = params[:date]
    @person = params[:person]
    @person_name = @person.first_name
    @resource_name = params[:resource_name]
    @resource_quantity = params[:resource_quantity]
    @request_link = params[:request_link]
    @title = params[:title]
    mail(to: @person.email, subject: "Reminder for: #{@title}")
  end

  def provider_thanks
    @organization_name = params[:organization_name]
    @person = params[:person]
    @person_name = @person.first_name
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Thank you!")
  end

  def provider_unassigned
    @person = params[:person]
    @person_name = @person.first_name
    @request_link = params[:request_link]
    @resource_name = params[:resource_name]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "You have been unassigned from a request")
  end

  def request_created_admin
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @person_name = @person.first_name
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "New request has been created")
  end

  def request_created_coordinator
    @person = params[:person]
    @person_name = @person.first_name
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Coordinator for new request")
  end

  def request_created_recipient
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @person_name = @person.first_name
    @request_link = params[:request_link]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "A new request has been created for you")
  end

  def request_deleted_admin
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @person_name = @person.first_name
    @recipient_name = params[:recipient_name]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Request has been canceled")
  end

  def request_deleted_coordinator
    @person = params[:person]
    @person_name = @person.first_name
    @recipient_name = params[:recipient_name]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Request has been canceled")
  end

  def request_deleted_provider
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @person_name = @person.first_name
    @recipient_name = params[:recipient_name]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Request has been canceled")
  end

  def request_updated_admin
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @person_name = @person.first_name
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Request has been updated")
  end

  def request_updated_coordinator
    @person = params[:person]
    @person_name = @person.first_name
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Request has been updated")
  end

  def request_updated_provider
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @person_name = @person.first_name
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Request has been updated")
  end

  def resource_deleted_provider
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @person_name = @person.first_name
    @recipient_name = params[:recipient_name]
    @resource_name = params[:resource_name]
    @title = params[:title]
    attachments.inline["logo.png"] = File.read("./public/logo.png")
    mail(to: @person.email, subject: "Your request assignment was removed")
  end
end
