# == Schema Information
#
# Table name: requests
#
#  id              :integer          not null, primary key
#  person_id       :integer          not null
#  organization_id :integer          not null
#  type            :string           not null
#  title           :string           not null
#  notes           :text
#  allergies       :text
#  start_date      :date
#  start_time      :time
#  end_date        :date
#  end_time        :time
#  street_line     :string
#  city            :string
#  state           :string
#  zip_code        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Request < ApplicationRecord
  belongs_to :organization
  belongs_to :person
  has_one :coordinator, dependent: :destroy
  has_many :delivery_dates, dependent: :destroy
  has_many :resources, dependent: :destroy

  validates :person_id, :organization_id, :type, :title, presence: true
end
