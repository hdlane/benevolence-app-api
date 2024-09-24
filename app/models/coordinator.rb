# == Schema Information
#
# Table name: coordinators
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  request_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Coordinator < ApplicationRecord
  belongs_to :person
  belongs_to :request

  # Presence validations
  validates :person_id, :request_id, presence: true
end
