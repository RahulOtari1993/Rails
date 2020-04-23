# == Schema Information
#
# Table name: participant_account_connects
#
#  id             :bigint           not null, primary key
#  participant_id :bigint
#  email          :string
#  token          :string
#  platform       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class ParticipantAccountConnect < ApplicationRecord
end
