class Submission < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :campaign
end
