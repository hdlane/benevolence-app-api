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
  has_many :coordinators, dependent: :destroy
  has_many :providers, dependent: :destroy
  has_many :requests, dependent: :destroy

  validates :organization_id, :first_name, :last_name, :pco_person_id, presence: true
end
