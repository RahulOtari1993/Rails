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
#  placeholder          :string
#  additional_details   :string
#  sequence             :integer
#
class Question < ApplicationRecord
  ## Associations
  belongs_to :challenge
  has_many :question_options, dependent: :destroy
  belongs_to :profile_attribute, optional: true
  has_many :participant_answers, dependent: :destroy

  ## ENUM
  enum category: {profile: 0, survey: 1, quiz: 2}
  enum answer_type: {string: 0, text_area: 1, boolean: 2, date: 3, time: 4, date_time: 5, number: 6, decimal: 7,
                     radio_button: 8, check_box: 9, wysiwyg: 10, dropdown: 11, image_radio_button: 12, image_check_box: 13}

  ## Nested Attributes
  accepts_nested_attributes_for :question_options, allow_destroy: true, :reject_if => :all_blank

  ## Modify JSON Response
  def as_json(options = {})
    response = super
    if options.has_key?(:include_options) && options[:include_options] == true
      ## Include Question Options in Response
      response = super.merge({ :option => question_options.as_json })
    end

    response
  end

end
