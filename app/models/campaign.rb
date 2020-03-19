class Campaign < ApplicationRecord
  ## Associations
  belongs_to :organization
  has_many :campaigns, dependent: :destroy
  has_many :rewards, dependent: :destroy
end
