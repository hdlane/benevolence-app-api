# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  email      :string           not null
#  synced_at  :datetime
#  pco_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Organization < ApplicationRecord
  has_many :people, dependent: :destroy
  has_many :requests, dependent: :destroy

  # Presence validations
  validates :name, :email, :pco_id, presence: true

  # Email validations
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "not a valid email address" }
end
