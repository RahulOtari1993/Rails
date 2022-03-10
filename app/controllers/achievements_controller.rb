class AchievementsController < ApplicationController 
  
  #Authentication for Signin/Signup
  before_action :authenticate_user!
  before_action :set_achievement, only: [:update, :show, :destroy]

  #List All Achievements API
  def index
    @achievements = Achievement.all
    render_success 200, true, 'Achievement fetched successfully', achievements.as_json
  end

  #Fetch an Achievement API
  def show
    render_success 200, true, 'Achievement fetched successfully', @achievement.as_json
  end

  #Create An Achievement API
  def create
    @achievement = Achievement.new(achievement_params)
    if @achievement.save
      render_success 200, true, 'Achievement Created Successfully', @achievement.as_json  
    else
      if @achievement.errors
        errors = @achievement.errors.full_messages.join(", ")
      else
        errors = 'Achievement creation failed'
      end
      return_error 500, false, errors, {}
    end
  end

  #Update an Achievement API
  def update
    if @achievement.update(achievement_params)
      render_success 200, true, 'Achievement updated successfully', @sport.as_json
    else
      if @sport.errors
        errors = @sport.errors.full_messages.join(", ")
      else
        errors = 'Sport update failed'
      end
      return_error 500, false, errors, {}
    end
  end

  #Delete an Achievement API
  def destroy
    @achievement.destroy
    render_success 200, true, 'Achievement deleted successfully', {}
  end

  private
    #Set Achievement Object, Return Error if not found
    def set_achievement
      @achievement = Achievement.find(params[:id])
    end

    #strong Params of Achievement
    def achievement_params
      params.require(:achievement).permit(:award, :medal, :user_id)
    end
end
