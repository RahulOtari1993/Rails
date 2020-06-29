class Admin::Campaigns::ParticipantsController < Admin::Campaigns::BaseController
  before_action :set_participant, only: [:show, :remove_tag, :add_tag, :add_note]

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

  # Fetch Participant Details
  def show
  end

  # Remove a Tag From Participant
  def remove_tag
    begin
      @participant.tag_list.remove(params[:tag], parse: true) if params.has_key?('tag') && params[:tag].present?
      @participant.save!
    rescue StandardError => e
      @message = e.message
    end
  end

  # Add a Tag to Participant
  def add_tag
    begin
      @participant.tag_list.add(params[:tag].join(', '), parse: true) if params.has_key?('tag') && params[:tag].present?
      @participant.save!
    rescue StandardError => e
      @message = e.message
    end
  end

  # Add a Note to Participant
  def add_note
    begin
      @note = Note.new(description: params[:description], campaign: @campaign, user: current_user, participant: @participant)
      @note.save! 
    rescue StandardError => e
      @message = e.message
    end
  end

  private

  def search_columns
    %w(first_name last_name email)
  end

  def sort_column
    columns = [%w[first_name last_name], ['email'], ['unused_points'], ['birth_date'], ['gender'], ['created_at']]
    columns[params[:order]['0'][:column].to_i - 1].join(', ')
  end

  def set_participant
    @participant = @campaign.participants.find_by_id(params[:id])
  end
end
