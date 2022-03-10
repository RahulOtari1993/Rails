class Business < ApplicationRecord
  validates :name, :address, :start_date, :end_date, presence: true
end
