# == Schema Information
#
# Table name: notes
#
#  id          		:bigint           not null, primary key
#  description    :text
#  campaign_id 		:bigint
#  user_id 				:bigint
#  participant_id :bigint
#  created_at  		:datetime         not null
#  updated_at  		:datetime         not null
#
class Note < ApplicationRecord
	# Associations
  belongs_to :campaign
  belongs_to :user
  belongs_to :participant

  # Validations
  validates :description, presence: { message: "cannot be blank." }
  validates :description, uniqueness: { scope: :campaign_id }
end
