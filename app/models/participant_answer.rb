# == Schema Information
#
# Table name: participant_answers
#
#  id                    :bigint           not null, primary key
#  campaign_id           :bigint
#  challenge_id          :bigint
#  question_id           :bigint
#  answer                :text
#  question_option_id    :bigint
#  participant_id        :bigint
#  result                :boolean
#  created_at            :datetime         not null
#  updated_at            :datetime         not null

class ParticipantAnswer < ApplicationRecord
  ## Associations
  belongs_to :campaign
  belongs_to :challenge
  belongs_to :question
  belongs_to :question_option, optional: true
  belongs_to :participant

  ## Validatations
  validates_presence_of :result

  ## Scopes
  scope :correct, -> { where(result: true) }


end
