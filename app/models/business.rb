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

end
