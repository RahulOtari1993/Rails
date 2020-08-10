class Admin::Campaigns::DashboardController < Admin::Campaigns::BaseController

  def index
    challenges = @campaign.challenges
    c_ids = challenges.pluck(:id)

    @start_date = challenges.minimum(:start).strftime('%d %b %Y')
    @chart_json = []
    if challenges.present?
      details = ParticipantAction.where(actionable_type: 'Challenge', actionable_id: c_ids, action_type: 8)
          .select("COUNT(id) as submission, DATE(created_at) as creation")
          .group('DATE(created_at)').order('DATE(created_at)')

      details.each do |val|
        @chart_json.push([(val.creation.to_datetime.to_i) * 1000, val.submission])
      end
    end
  end
end
