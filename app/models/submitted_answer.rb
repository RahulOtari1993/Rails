# == Schema Information
#
# Table name: submitted_answers
#
#  id                 :bigint           not null, primary key
#  challenge_id       :bigint
#  question_id        :bigint
#  participant_id     :bigint
#  question_option_id :bigint
#  answer             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class SubmittedAnswer < ApplicationRecord
  ## Associations
  belongs_to :challenge
  belongs_to :question
  belongs_to :participant
end
