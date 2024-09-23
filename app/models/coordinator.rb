class Coordinator < ApplicationRecord
  belongs_to :person
  belongs_to :request
end
