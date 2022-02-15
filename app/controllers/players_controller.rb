class PlayersController < ApplicationController
  before_action :get_sport
  before_action :set_player, only: %i[ show edit update destroy ]

  # GET /players or /players.json
  def index
    @players = @sport.players
  end

  # GET /players/1 or /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = @sport.players.build
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players or /players.json
  def create
    @player = @sport.players.build(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to sport_players_path(@sport), notice: "Player was successfully created." }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to sport_player_path(@sport), notice: "Player was successfully updated." }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @player.destroy
    # redirect_to destroy_user_session_path
    respond_to do |format|
      format.html { redirect_to sport_players_path(@sport), notice: "Player was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def get_sport
    @sport = Sport.friendly.find(params[:sport_id])
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = @sport.players.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:player_name, :player_city, :player_state, :player_country, :phone, :gender, :sport_id, :image, :email, :user_id)
    end

end
