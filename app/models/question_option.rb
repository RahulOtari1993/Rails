# == Schema Information
#
# Table name: question_options
#
#  id          :bigint           not null, primary key
#  question_id :bigint
#  details     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  answer      :string
#  sequence    :integer
#  image       :string
#
class QuestionOption < ApplicationRecord
  ## Associations
  belongs_to :question
  has_one :participant_answer

  ## Mount Uploader for File Upload
  mount_uploader :image, ImageOptionUploader
end
