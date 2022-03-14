# == Schema Information
#
# Table name: businesses
#
#  id         :bigint           not null, primary key
#  name       :string
#  address    :string
#  start_date :datetime
#  end_date   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Business < ApplicationRecord

  # CSV FILE
  def self.to_csv(fields = column_names, options = {})
    CSV.generate(options) do |csv|
      csv << fields
      all.each do |business|
        csv << business.attributes.values_at(*fields)
      end
    end
  end 

  # VALIDATIONS
  validates :name, :address, :start_date, :end_date, presence: true

  # Associations
  has_many :offers

end
