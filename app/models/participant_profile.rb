# == Schema Information
#
# Table name: participant_profiles
#
#  id                   :bigint           not null, primary key
#  participant_id       :bigint
#  profile_attribute_id :bigint
#  value                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class ParticipantProfile < ApplicationRecord
end
