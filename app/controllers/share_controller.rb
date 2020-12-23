class ShareController < ApplicationController

  layout 'end_user'
  # URL endpoint for social share challenges
  # People following the social post link
  # end up here
  def show
    begin
      
      @challenge = @campaign.challenges.find(params[:id])
      @og = get_open_graph @challenge

      Rails.logger.info "================ @og: #{@og.inspect} ========================="
    rescue Exception=>e
      # No campaign or challenge with ID for campaign
    end
  end
end
