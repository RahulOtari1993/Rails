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
end
