# == Schema Information
#
# Table name: requests
#
#  id              :integer          not null, primary key
#  recipient_id    :integer          not null
#  coordinator_id  :integer          not null
#  organization_id :integer          not null
#  creator_id      :integer          not null
#  request_type    :string           not null
#  title           :string           not null
#  notes           :text
#  allergies       :text
#  start_date      :date             not null
#  end_date        :date
#  street_line     :string
#  city            :string
#  state           :string
#  zip_code        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Request < ApplicationRecord
  before_validation :normalize_dates

  belongs_to :organization
  # has_one :recipient, dependent: :destroy
  # has_one :coordinator, dependent: :destroy
  # has_one :creator, dependent: :destroy
  has_many :resources, dependent: :destroy
  has_many :providers, through: :resources
  has_many :delivery_dates

  # Presence validations
  validates :recipient_id, :coordinator_id, :creator_id, :organization_id, :request_type, :start_date, :title, presence: true

  # String validations
  validates :request_type, inclusion: { in: [ "Donation", "Meal", "Service" ], message: "%{value} is not a valid type" }
  validates :title, length: { maximum: 100, too_long: "%{count} characters is the maximum allowed" }
  validates :notes, length: { maximum: 1000, too_long: "%{count} characters is the maximum allowed" }
  validates :allergies, length: { maximum: 250, too_long: "%{count} characters is the maximum allowed" }
  validates :street_line, length: { maximum: 100, too_long: "%{count} characters is the maximum allowed" }
  validates :city, length: { maximum: 50, too_long: "%{count} characters is the maximum allowed" }
  validates :state, length: { is: 2, wrong_length: "only %{count} characters are allowed" }
  validates :zip_code, length: { is: 5 || 10, wrong_length: "only 5 or 10 characters are allowed (XXXXX) / (XXXXX-XXXX)" }

  # Date validations
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }, if: -> { start_date.present? }

  def requests_fulfilled
    fulfilled = 0
    self.resources.each do |resource|
      resource.fulfilled? ? fulfilled = fulfilled + 1 : nil
    end
    fulfilled
  end

  private
    def normalize_dates
      return unless start_date.present? && !end_date.present?
      self.end_date = start_date
    end
end
