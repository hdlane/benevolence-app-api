# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  organization_id :integer          not null
#  first_name      :string           not null
#  last_name       :string           not null
#  name            :string
#  email           :string
#  phone_number    :string
#  is_admin        :boolean
#  pco_person_id   :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Person < ApplicationRecord
  belongs_to :organization
  has_many :recived_requests, class_name: "Request", foreign_key: "recipient_id", dependent: :destroy
  has_many :coordinated_requests, class_name: "Request", foreign_key: "coordinator_id", dependent: :destroy
  has_many :providers, dependent: :destroy

  # Presence validations
  validates :organization_id, :first_name, :last_name, :name, :pco_person_id, presence: true

  # Email validations
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "not a valid email address" }
end
