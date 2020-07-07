class EmailSetting < ApplicationRecord
  ## Associations
  belongs_to :campaign
  has_many :participants
end
