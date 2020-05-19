# == Schema Information
#
# Table name: questions
#
#  id           :bigint           not null, primary key
#  challenge_id :bigint
#  category     :integer
#  title        :string
#  is_required  :boolean
#  answer_type  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Question < ApplicationRecord
  ## Associations
  belongs_to :challenge
  has_many :question_options, dependent: :destroy
  has_many :question_answers, dependent: :destroy
end
