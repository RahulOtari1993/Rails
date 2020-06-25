class Admin::Campaigns::ParticipantsController < Admin::Campaigns::BaseController
  def index
  end

  def fetch_participants
    participants = @campaign.participants
    search_string = []
    filter_query = ''

    ## Check if Search Keyword is Present & Write it's Query
    if params.has_key?('search') && params[:search].has_key?('value') && params[:search][:value].present?
      terms = params[:search][:value].split(' ')

      search_columns.each do |column|
        terms.each do |term|
          search_string << "#{column} ILIKE '%#{term}%'"
        end
      end
      participants = participants.where(search_string.join(' OR '))
    end

    if params["filters"].present?
      filters = JSON.parse(params["filters"].gsub("=>", ":").gsub(":nil,", ":null,"))
      participants = participants.side_bar_filter(filters)
    end

    participants = participants.order("#{sort_column} #{datatable_sort_direction}") unless sort_column.nil?
    participants = participants.page(datatable_page).per(datatable_per_page)

    render json: {
        participants: participants.as_json,
        draw: params['draw'].to_i,
        recordsTotal: @campaign.participants.count,
        recordsFiltered: participants.total_count,
    }
  end

  ## Fetch Filtered Participants
  def participants
    @participants = @campaign.participants
    search_string = []

    if params['filters'].present?
      ## Check if Search Keyword is Present & Write it's Query
      if params['filters']['search_term'].present?
        terms = params['filters']['search_term'].split(' ')
        search_columns.each do |column|
          terms.each do |term|
            search_string << "#{column} ILIKE '%#{term}%'"
          end
        end
        @participants = @participants.where(search_string.join(' OR '))
      end

      @participants = @participants.side_bar_filter(params['filters'])
    end
  end

  ## Export Filtered Participants as a CSV File
  def export_participants
    participants = Participant.all
    results = CSV.generate do |csv|
      ## Generate CSV File the Header
      csv << %w(first_name last_name email joined_date)

      ## Add Records in CSV File
      participants.each do |participant|
        csv << [participant.first_name, participant.last_name, participant.email, participant.created_at]
      end
    end

    ## Logic to Download the Generated CSV File
    return send_data results, type: 'text/csv; charset=utf-8; header=present',
                     disposition: 'attachment; filename=campaign_contacts.csv'
  end
  private

  def search_columns
    %w(first_name last_name email)
  end

  def sort_column
    columns = [%w[first_name last_name], ['email'], ['unused_points'], ['birth_date'], ['gender'], ['created_at']]
    columns[params[:order]['0'][:column].to_i - 1].join(', ')
  end
end
