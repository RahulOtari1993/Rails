class Sportannouncement < ApplicationRecord
  belongs_to :sport
  extend FriendlyId
  friendly_id :msg, use: :slugged
end
