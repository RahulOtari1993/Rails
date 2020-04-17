# == Schema Information
#
# Table name: challenge_filters
#
#  id                  :bigint           not null, primary key
#  challenge_id        :bigint
#  challenge_event     :string
#  challenge_condition :string
#  challenge_value     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class ChallengeFilter < ApplicationRecord

  ## Associations
  belongs_to :challenge
  
end
