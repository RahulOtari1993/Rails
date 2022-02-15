class SportannouncementsController < ApplicationController
  before_action :get_sport
  before_action :set_sportannouncement, only: %i[ show edit update destroy ]

  # GET /sportannouncements or /sportannouncements.json
  def index
    @sportannouncements = @sport.sportannouncements
  end

  # GET /sportannouncements/1 or /sportannouncements/1.json
  def show
  end

  # GET /sportannouncements/new
  def new
    @sportannouncement = @sport.sportannouncements.build
  end

  # GET /sportannouncements/1/edit
  def edit
  end

  # POST /sportannouncements or /sportannouncements.json
  def create
    @sportannouncement = @sport.sportannouncements.build(sportannouncement_params)

    respond_to do |format|
      if @sportannouncement.save
        AnnouncementMailer.announcement_created.deliver_later
        format.html { redirect_to sport_sportannouncements_path(@sport), notice: "Sportannouncement was successfully created." }
        format.json { render :show, status: :created, location: @sportannouncement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sportannouncement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sportannouncements/1 or /sportannouncements/1.json
  def update
    respond_to do |format|
      if @sportannouncement.update(sportannouncement_params)
        format.html { redirect_to sport_sportannouncement_path(@sport), notice: "Sportannouncement was successfully updated." }
        format.json { render :show, status: :ok, location: @sportannouncement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sportannouncement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sportannouncements/1 or /sportannouncements/1.json
  def destroy
    @sportannouncement.destroy

    respond_to do |format|
      format.html { redirect_to sport_sportannouncements_path(@sport), notice: "Sportannouncement was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
     def get_sport
       @sport = Sport.friendly.find(params[:sport_id])
     end
    def set_sportannouncement
      @sportannouncement = @sport.sportannouncements.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sportannouncement_params
      params.require(:sportannouncement).permit(:msg, :sport_id)
    end
end
