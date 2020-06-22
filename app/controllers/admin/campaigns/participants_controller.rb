class Admin::Campaigns::ParticipantsController < Admin::Campaigns::BaseController
  def index
    @participants = @campaign.participants
  end

  def generate_reward_json
    filters_query = ''
    search_string = []

    rewards = @campaign.rewards
    ## Check if Search Keyword is Present & Write it's Query
    if params.has_key?('search') && params[:search].has_key?('value') && params[:search][:value].present?
      search_columns.each do |term|
        search_string << "#{term} ILIKE :search"
      end
    end

    ## Check for Filters
    if params["filters"].present?
      filters = JSON.parse(params["filters"].gsub("=>", ":").gsub(":nil,", ":null,"))
      filters_query = rewards.reward_side_bar_filter(filters)
    end

    rewards = rewards.where(search_string.join(' OR '), search: "%#{params[:search][:value]}%").where(filters_query)
    rewards = rewards.order("#{sort_column} #{datatable_sort_direction}") unless sort_column.nil?

    rewards = rewards.page(datatable_page).per(datatable_per_page)

    render json: {
        rewards: rewards.as_json,
        draw: params['draw'].to_i,
        recordsTotal: rewards.count,
        recordsFiltered: rewards.total_count
    }
  end

  private

  def search_columns
    %w(first_name last_name email)
  end

  def sort_column
    columns = %w(first_name last_name email unused_points)
    columns[params[:order]['0'][:column].to_i - 1]
  end
end