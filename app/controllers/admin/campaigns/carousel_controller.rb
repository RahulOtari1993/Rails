class Admin::Campaigns::CarouselController < Admin::Campaigns::BaseController

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
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

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
