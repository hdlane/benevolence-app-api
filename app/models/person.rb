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
  before_save :set_name

  belongs_to :organization
  has_many :coordinators, dependent: :destroy
  has_many :providers, dependent: :destroy
  has_many :requests, dependent: :destroy

  # Presence validations
  validates :organization_id, :first_name, :last_name, :pco_person_id, presence: true

  # Email validations
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "not a valid email address" }

  private
    def set_name
      self.name = "#{first_name} #{last_name}"
    end
end
