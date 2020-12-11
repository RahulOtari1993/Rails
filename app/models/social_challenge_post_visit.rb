# == Schema Information
#
# Table name: social_challenge_post_visits
#
#  id                              :bigint           not null, primary key
#  challenge_id                    :bigint
#  participant_id                  :bigint
#  network_page_post_attachment_id :integer
#  points                          :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
class SocialChallengePostVisit < ApplicationRecord
  belongs_to :challenge
  belongs_to :participant
end
