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

  validates :name, :email, :pco_id, presence: true
end
