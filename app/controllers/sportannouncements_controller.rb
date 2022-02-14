class SportannouncementsController < ApplicationController
  before_action :set_sportannouncement, only: %i[ show edit update destroy ]

  # GET /sportannouncements or /sportannouncements.json
  def index
    @sportannouncements = Sportannouncement.all
  end

  # GET /sportannouncements/1 or /sportannouncements/1.json
  def show
  end

  # GET /sportannouncements/new
  def new
    @sportannouncement = Sportannouncement.new
  end

  # GET /sportannouncements/1/edit
  def edit
  end

  # POST /sportannouncements or /sportannouncements.json
  def create
    @sportannouncement = Sportannouncement.new(sportannouncement_params)

    respond_to do |format|
      if @sportannouncement.save
        AnnouncementMailer.announcement_created.deliver_later
        format.html { redirect_to sportannouncement_url(@sportannouncement), notice: "Sportannouncement was successfully created." }
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
        format.html { redirect_to sportannouncement_url(@sportannouncement), notice: "Sportannouncement was successfully updated." }
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
      format.html { redirect_to sportannouncements_url, notice: "Sportannouncement was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sportannouncement
      @sportannouncement = Sportannouncement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sportannouncement_params
      params.require(:sportannouncement).permit(:msg, :sport_id)
    end
end
