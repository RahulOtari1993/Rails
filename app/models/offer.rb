# == Schema Information
#
# Table name: offers
#
#  id          :bigint           not null, primary key
#  title       :string
#  description :string
#  coupon      :string
#  start_date  :datetime
#  end_date    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Offer < ApplicationRecord

  ## Tags
  acts_as_taggable_on :tags
  
  #Associations
  belongs_to :campaign
  # belongs_to :organization

  ## Validations
  # validates :title, :description, :coupon, :start_date, :end_date, presence: true
end
