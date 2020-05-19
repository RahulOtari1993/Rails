# == Schema Information
#
# Table name: question_options
#
#  id           :bigint           not null, primary key
#  challenge_id :bigint
#  question_id  :bigint
#  details      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class QuestionOption < ApplicationRecord
  ## Associations
  belongs_to :challenge
  belongs_to :question
end
