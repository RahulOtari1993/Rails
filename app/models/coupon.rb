# == Schema Information
#
# Table name: coupons
#
#  id         :bigint           not null, primary key
#  reward_id  :bigint
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Coupon < ApplicationRecord
  ## Associations
  belongs_to :reward
end
