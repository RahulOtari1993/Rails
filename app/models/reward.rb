class Reward < ApplicationRecord
  ## Associations
  belongs_to :campaign
  has_many :coupons
end
