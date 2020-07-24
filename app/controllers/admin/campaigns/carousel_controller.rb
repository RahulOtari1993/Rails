class Admin::Campaigns::CarouselController < Admin::Campaigns::BaseController
  before_action :set_carousel, only: [:edit, :update, :destroy]

  def index
  end

  def fetch_carousels
    carousels = @campaign.carousels
    search_string = []

    ## Check if Search Keyword is Present & Write it's Query
    if params.has_key?('search') && params[:search].has_key?('value') && params[:search][:value].present?
      search_columns.each do |term|
        search_string << "#{term} ILIKE :search"
      end
      carousels = carousels.where(search_string.join(' OR '), search: "%#{params[:search][:value]}%")
    end

    carousels = carousels.order("#{sort_column} #{datatable_sort_direction}") unless sort_column.nil?
    carousels = carousels.page(datatable_page).per(datatable_per_page)

    render json: {
        carousels: carousels.as_json(type: 'list'),
        draw: params['draw'].to_i,
        recordsTotal: @campaign.carousels.count,
        recordsFiltered: carousels.total_count,
    }
  end

  def new
    @carousel = @campaign.carousels.new
  end

  def create
    @carousel = @campaign.carousels.new(carousel_params)

    respond_to do |format|
      if @carousel.save
        format.html { redirect_to admin_campaign_carousel_index_path(@campaign), notice: 'Carousel was successfully created.' }
        format.json { render :index, status: :created }
      else
        format.html { render :new }
        format.json { render json: @carousel.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @carousel.update(carousel_params)
        format.html { redirect_to admin_campaign_carousel_index_path(@campaign), notice: 'Carousel was successfully updated.' }
        format.json { render :edit, status: :updated }
      else
        format.html { render :edit }
        format.json { render json: @carousel.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @carousel.destroy
        format.html { redirect_to admin_campaign_carousel_index_path(@campaign), notice: 'Carousel was deleted successfully.' }
        format.json { render :edit, status: :updated }
      else
        format.html { render :index }
        format.json { render json: @carousel.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def carousel_params
      params.require(:carousel).permit(:title, :description, :link, :image, :button_text)
    end

    def set_carousel
      @carousel = @campaign.carousels.find_by(:id => params[:id]) rescue nil
    end

    ## Datatable Column List om which search can be performed
    def search_columns
      %w(title description)
    end

    ## Datatable Column List on which sorting can be performed
    def sort_column
      columns = %w(title description)
      columns[params[:order]['0'][:column].to_i - 1]
    end
end
