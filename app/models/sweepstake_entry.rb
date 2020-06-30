class SweepstakeEntry < ApplicationRecord
  belongs_to :reward
  belongs_to :participant
end
