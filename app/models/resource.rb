# == Schema Information
#
# Table name: resources
#
#  id              :integer          not null, primary key
#  request_id      :integer          not null
#  organization_id :integer          not null
#  name            :string
#  kind            :string           not null
#  quantity        :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Resource < ApplicationRecord
  belongs_to :organization
  belongs_to :request
  has_one :delivery_date, dependent: :destroy
  has_many :providers, dependent: :destroy

  # Presence validations
  validates :request_id, :organization_id, :kind, :quantity, presence: true

  # Number validations
  validates :quantity, numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates :assigned, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def assign_resource!(assign_count)
    if available_resources >= assign_count
      increment!(:assigned, assign_count)
    else
      errors.add(:base, "No available assignments left")
      false
    end
  end

  def unassign_resource!(assign_count)
    if assigned >= assign_count
      decrement!(:assigned, assign_count)
    else
      errors.add(:base, "No assignments to unassign")
      false
    end
  end

  def available_resources
    quantity - assigned
  end
end
