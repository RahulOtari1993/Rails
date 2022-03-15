class BusinessesController < ApplicationController
  before_action :set_business, only: %i[ show edit update destroy ]

  def index
    @businesses = Business.all
    respond_to do |format|
      format.html
      format.csv { send_data @businesses.to_csv(['name', 'address', 'start_date', 'end_date']) }
    end
  end

  def show
  end
 
  def new
    @business = Business.new
  end

  def edit
  end

  def fetch_businesses
    # binding.pry
    businesses = Business.all
    search_string = []
    # binding.pry
    filter_query = ''
    response = []

    ## Check if Search Keyword is Present & Write it's Query
    if params.has_key?('search') && params[:search].has_key?('value') && params[:search][:value].present?
      search_columns.each do |term|
        search_string << "#{term} ILIKE :search"
      end
      businesses = businesses.where(search_string.join(' OR '), search: "%#{params[:search][:value]}%")
    end

    if params["filters"].present?
      filters = JSON.parse(params["filters"].gsub("=>", ":").gsub(":nil,", ":null,"))
      businesses = businesses.business_side_bar_filter(filters)
    end

    businesses = businesses.order("#{sort_column} #{datatable_sort_direction}") unless sort_column.nil?
    businesses = businesses.page(datatable_page).per(datatable_per_page)

    businesses.each do |business|
      json = business.as_json
      json['start'] = business.start_date.strftime("at %I:%M %p %Y %m %d")
      json['end'] = business.end_date.strftime("at %I:%M %p %Y %m %d")
      response.push(json)
    end 
    render json: {
        businesses: response,
        draw: params['draw'].to_i,
        recordsTotal: businesses.count,
        recordsFiltered: businesses.total_count,
    }
  end


  def create
    @business = Business.new(business_params)

    respond_to do |format|
      if @business.save
        format.html { redirect_to business_url(@business), notice: "business was successfully created." }
        format.json { render :show, status: :created, location: @business }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html { redirect_to business_url(@business), notice: "business was successfully updated." }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @business.destroy

    respond_to do |format|
      format.html { redirect_to businesses_url, notice: "business was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def search_columns
    %w(name address)
  end

  ## Datatable Column List on which sorting can be performed
  def sort_column
    columns = %w(name points completions clicks start created_at)
    columns[params[:order]['0'][:column].to_i - 1]
  end


  def set_business
    @business = Business.find(params[:id])
  end

  def business_params
    params.require(:business).permit(:name, :address, :start_date, :end_date)
  end
end
