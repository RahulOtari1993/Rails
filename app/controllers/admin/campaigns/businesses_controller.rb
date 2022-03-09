class Admin::Campaigns::BusinessesController < Admin::Campaigns::BaseController
  before_action :set_business, only: [:edit, :update, :show]
  
  def index
  end

  def fetch_businesses
    # binding.pry
    businesses = @campaign.businesses
    search_string = []
    # binding.pry
    filter_query = ''

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

    render json: {
        businesses: businesses.as_json(type: 'list'),
        draw: params['draw'].to_i,
        recordsTotal: @campaign.businesses.count,
        recordsFiltered: businesses.total_count,
    }
  end

  def new
    @business = Business.new
    @connect_facebook = @campaign.networks.current_active.where(platform: 'facebook').first
    @connect_instagram = @campaign.networks.current_active.where(platform: 'instagram').first
  end

  def create
    @business = Business.new(build_business_params)

    respond_to do |format|
      tags_association ## Manage Tags for a Challenge
      if @business.save
        # binding.pry
        format.html { redirect_to admin_campaign_businesses_path(@campaign), success: 'Business was successfully created.' }
        format.json { render :index, status: :created }
      else
        format.html { render :new }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    # binding.pry
    @connect_facebook = @campaign.networks.current_active.where(platform: 'facebook').first
    @connect_instagram = @campaign.networks.current_active.where(platform: 'instagram').first
  end

  ## Remove a Tag From Challenge
  def remove_tag
    @message = ''
    begin
      @business.tag_list.remove(params[:tag], parse: true) if params.has_key?('tag') && params[:tag].present?
      @business.save!
    rescue StandardError => e
      @message = e.message
    end
  end

  ## Add a Tag to Challenge
  def add_tag
    @message = ''
    begin
      @business.tag_list.add(params[:tag].join(', '), parse: true) if params.has_key?('tag') && params[:tag].present?
      @business.save!
    rescue StandardError => e
      @message = e.message
    end
  end

  private

   ## Datatable Column List om which search can be performed
  def search_columns
    %w(name business_type)
  end

  ## Datatable Column List on which sorting can be performed
  def sort_column
    columns = %w(name points completions clicks start created_at)
    columns[params[:order]['0'][:column].to_i - 1]
  end

  def set_business
    @business = @campaign.businesses.find_by(:id => params[:id]) rescue nil
  end

  ## Assign/Remove Tags to a Challenge
  def tags_association
    tags = params[:business][:tags].reject { |c| c.empty? } if params[:business].has_key?('tags')
    removed_tags = @business.tag_list - tags

    @business.tag_list.remove(removed_tags.join(', '), parse: true) if removed_tags.present?
    @business.tag_list.add(tags.join(', '), parse: true) if tags.present?
  end


  ## Build Questions Params
  def build_business_params
   params.require(:business).permit(:name, :address, :logo, :working_hours, :organization_id, :campaign_id)
  end
end
