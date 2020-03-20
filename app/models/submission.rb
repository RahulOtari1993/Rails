# == Schema Information
#
# Table name: submissions
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  campaign_id      :bigint
#  submissible_id   :integer
#  submissible_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Submission < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :campaign
end
