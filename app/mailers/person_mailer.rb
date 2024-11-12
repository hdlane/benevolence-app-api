class PersonMailer < ApplicationMailer
  def mail_login_link
    @person = params[:person]
    @url = params[:url]
    mail(to: @person.email, subject: "Login to Benevolence App")
  end

  def organization_created
    @person = params[:person]
    @recipient_name = params[:recipient_name]
  end

  def organization_deleted
    @person = params[:person]
    @recipient_name = params[:recipient_name]
  end

  def provider_assigned
    @date = params[:date]
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
  end

  def provider_reminder
    @date = params[:date]
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
  end

  def provider_thanks
    @date = params[:date]
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
  end

  def provider_unassigned
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @resource_name = params[:resource_name]
    @title = params[:title]
  end

  def request_created_admin
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
  end

  def request_created_coordinator
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
  end

  def request_created_recipient
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
  end

  def request_deleted_admin
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @title = params[:title]
  end

  def request_deleted_coordinator
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @title = params[:title]
  end

  def request_deleted_provider
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @title = params[:title]
  end

  def request_updated_admin
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
  end

  def request_updated_coordinator
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
  end

  def request_updated_provider
    @coordinator_name = params[:coordinator_name]
    @person = params[:person]
    @recipient_name = params[:recipient_name]
    @request_link = params[:request_link]
    @title = params[:title]
  end
end
