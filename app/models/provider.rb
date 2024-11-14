# == Schema Information
#
# Table name: providers
#
#  id          :integer          not null, primary key
#  person_id   :integer          not null
#  resource_id :integer          not null
#  quantity    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Provider < ApplicationRecord
  # remove whatever quantity was assigned to a resource for reassignment
  before_destroy :unassign_resources

  belongs_to :person
  belongs_to :resource
  has_one :delivery_date, through: :provider_delivery_date

  # Presence validations
  validates :person_id, :resource_id, :quantity, presence: true

  # Number validations
  validates :quantity, numericality: { greater_than_or_equal_to: 1, only_integer: true }

  private
    def unassign_resources
      self.resource.unassign_resource!(self.quantity)
      if self.resource.kind == "Meal"
        self.resource.update!(name: nil)
      end
    end
end
