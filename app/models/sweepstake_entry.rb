# == Schema Information
#
# Table name: sweepstake_entries
#
#  id             :bigint           not null, primary key
#  reward_id      :bigint
#  participant_id :bigint
#  winner         :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class SweepstakeEntry < ApplicationRecord
  belongs_to :reward
  belongs_to :participant
end
