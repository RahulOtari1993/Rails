class AchievementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_achievement, only: [:update, :show, :destroy]

  # GET /achievements
  def index
    @achievements = Achievement.all

    render json: @achievements
  end

  # GET /achievements/1
  def show
    render json: @achievement
  end

  # POST /achievements
  def create
    @achievement = Achievement.new(achievement_params)

    if @achievement.save
      render json: @achievement, status: :created, location: @achievement  
    else
       render json: @achievement.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /achievements/1
  def update
    if @achievement.update(achievement_params)
      render json: @achievement
    else
      render json: @achievement.errors, status: :unprocessable_entity
    end
  end

  # DELETE /achievements/1
  def destroy
    @achievement.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_achievement
      @achievement = Achievement.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def achievement_params
       params.require(:achievement).permit(:award, :medal, :user_id)
    end
end
