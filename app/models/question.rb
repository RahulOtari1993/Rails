# == Schema Information
#
# Table name: questions
#
#  id                   :bigint           not null, primary key
#  challenge_id         :bigint
#  category             :integer
#  title                :string
#  is_required          :boolean          default(FALSE)
#  answer_type          :integer
#  profile_attribute_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Question < ApplicationRecord
  ## Associations
  belongs_to :challenge
  has_many :question_options, dependent: :destroy
  has_many :submitted_answers, dependent: :destroy
  belongs_to :profile_attribute, optional: true

  ## ENUM
  enum filter_type: {profile: 0, survey: 1, quiz: 1}
  enum answer_type: {string: 0, text_area: 1, boolean: 2, date: 3, time: 4, date_time: 5, number: 6, decimal: 7,
                     radio_button: 8, check_box: 9, wysiwyg: 10, dropdown: 11}

  ## Nested Attributes
  accepts_nested_attributes_for :question_options, allow_destroy: true, :reject_if => :all_blank
end
