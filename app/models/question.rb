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

  ## ENUM
  enum filter_type: {profile: 0, survey: 1, quiz: 1}

  ## Nested Attributes
  accepts_nested_attributes_for :question_options, allow_destroy: true, :reject_if => :all_blank
end
