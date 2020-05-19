class ProfileAttribute < ApplicationRecord

  ## Associations
  belongs_to :campaign

  ## ENUM
  enum field_type: {string: 0, text_area: 1, boolean: 2, date: 3, time: 4, date_time: 5, number: 6, decimal: 7, radio_button: 8, check_box: 9}

  ## Validations
  validates :attribute_name, :display_name, :field_type, presence: true
  validates :attribute_name, uniqueness: true
end
