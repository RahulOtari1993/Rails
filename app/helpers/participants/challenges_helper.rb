module Participants::ChallengesHelper

  def get_challenge_video_id(challenge)
    VideoInfo.new(challenge.link).video_id
  end

  def is_question_required(question)
    question.is_required ? 'question_required' :  false
  end

  def fetch_feeds(campaign, challenge)
    network = campaign.networks.current_active.where(platform: challenge.parameters).first
    posts = network.network_page_posts.order(created_time: :desc).pluck(:id)
    NetworkPagePostAttachment.where(network_page_post_id: posts).order(created_at: :desc).page(1).per(4)
  end

  def fetch_post_visited(challenge, post_attachment)
     challenge.social_challenge_post_visits.where(network_page_post_attachment_id: post_attachment.id, participant_id: current_participant.id).first.present?
  end

  def fetch_remaining_post_visit_count(campaign, challenge)
    network = campaign.networks.current_active.where(platform: challenge.parameters).first
    posts = network.network_page_posts.order(created_time: :desc).pluck(:id)
    attachment_ids = NetworkPagePostAttachment.where(network_page_post_id: posts).order(created_at: :desc).pluck(:id)
    visited_attachment_ids = challenge.social_challenge_post_visits.where(participant_id: current_participant.id).pluck(:network_page_post_attachment_id)
    unvisit_count = (attachment_ids - visited_attachment_ids).length

    unvisit_count > 0 ? unvisit_count : 0
  end
end
