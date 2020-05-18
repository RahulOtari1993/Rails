class ProfileAttribute < ApplicationRecord

  ## Associations
  belongs_to :campaign

  ## ENUM
  enum field_type: {string: 0, text_area: 1, boolean: 2, date: 3, time: 4, date_time: 5, number: 6, decimal: 7}
end
