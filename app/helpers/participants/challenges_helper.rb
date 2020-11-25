module Participants::ChallengesHelper

  def get_challenge_video_id(challenge)
    video_id = VideoInfo.new(challenge.link).video_id
  end

  def is_question_required(question)
    result = question.is_required ? 'question_required' :  false
    result
  end

  def fetch_facebook_feed(campaign)
    # ntw_page_posts = campaign.network_page_posts.order(created_time: :desc)
    # ntw_page_posts_attachments = ntw_page_posts.order(created_time: :desc).map(&:network_page_post_attachments).flatten.sort_by {|x| x.created_at}.reverse
    ntw_page_post_ids = campaign.network_page_posts.order(created_time: :desc).pluck(:id)
    ntw_page_posts_attachments = NetworkPagePostAttachment.where(network_page_post_id: ntw_page_post_ids).order(created_at: :desc).page(1).per(4)
    ntw_page_posts_attachments
  end

  def fetch_facebook_post_visited(challenge, post_attachment)
     result = challenge.social_challenge_post_visits.where(network_page_post_attachment_id: post_attachment.id, participant_id: current_participant.id).first.present?
     result
  end

  def fetch_remaining_post_visit_count(campaign, challenge)
    unvisit_count = 0
    ntw_page_post_ids = campaign.network_page_posts.order(created_time: :desc).pluck(:id)
    ntw_page_posts_atchmt_ids = NetworkPagePostAttachment.where(network_page_post_id: ntw_page_post_ids).order(created_at: :desc).pluck(:id)
    visited_post_atchmt_ids = challenge.social_challenge_post_visits.where(participant_id: current_participant.id).pluck(:network_page_post_attachment_id)
    unvisit_count = (ntw_page_posts_atchmt_ids - visited_post_atchmt_ids).length
    unvisit_count
  end
end
