class LoginLinkCreation
  def initialize(email, person)
    @email = email
    @person = person
  end

  def create_login_link
    token = @person.to_sgid.to_s
    PersonMailer.with(
      person: @person,
      url: "#{CLIENT_DOMAIN}/login/verify?token=#{token}"
    ).mail_login_link.deliver_later
  end
end
