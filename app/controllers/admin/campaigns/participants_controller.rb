class Admin::Campaigns::ParticipantsController < Admin::Campaigns::BaseController
  before_action :set_participant, only: [:show, :remove_tag, :add_tag, :add_note, :update_status, :activities_list, :rewards_list, :notes_list]

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

  ## Fetch Filtered Participants & Create CSV
  def participants
    @participants = @campaign.participants
    search_string = []
    filters = JSON.parse params[:filters]

    if params['filters'].present? && filters.present?
      ## Check if Search Keyword is Present & Write it's Query
      if filters['search_term'].present?
        terms = filters['search_term'].split(' ')
        search_columns.each do |column|
          terms.each do |term|
            search_string << "#{column} ILIKE '%#{term}%'"
          end
        end
        @participants = @participants.where(search_string.join(' OR '))
      end

      @participants = @participants.side_bar_filter(filters)
    end

    results = CSV.generate do |csv|
      ## Generate CSV File the Header
      csv << %w(first_name last_name email joined_date)

      ## Add Records in CSV File
      @participants.each do |participant|
        csv << [participant.first_name, participant.last_name, participant.email, participant.created_at]
      end
    end

    ## Logic to Download the Generated CSV File
    return send_data results, type: 'text/csv; charset=utf-8; header=present',
                     disposition: 'attachment; filename=campaign_contacts.csv'
  end

  # Getting Date For Apex Chart & Graph
  def get_data_for_chart_graph
    participants = @campaign.participants

    data = {
        genderElementCount: Participant.by_gender(participants),
        ageElementCount: Participant.by_age(participants),
        completedChallengesElementCount: Participant.by_completed_challenges(@campaign),
        connectedPlatformElementCount: Participant.by_connected_platform
    }

    # binding.pry

    render json: data
  end

  # Getting Activities Feed List
  def activities_list
    actions = @participant.participant_actions
    actions = actions.order("#{sort_column_for_activity} #{datatable_sort_direction}") unless sort_column_for_activity.nil?
    actions = actions.page(datatable_page).per(datatable_per_page)
    render json: {
      participant_actions: actions.as_json,
      draw: params['draw'].to_i,
      recordsTotal: actions.count,
      recordsFiltered: actions.total_count
    }
  end

  # Getting Rewards List
  def rewards_list
    participants = @participant.reward_participants.joins(:reward)
    participants = participants.order("#{sort_column_for_reward} #{datatable_sort_direction}")
    participants = participants.page(datatable_page).per(datatable_per_page)
    render json: {
      reward_participants: participants.map {|r| r.reward.as_json},
      draw: params['draw'].to_i,
      recordsTotal: participants.count,
      recordsFiltered: participants.total_count
    }
  end

  # Getting Notes List
  def notes_list
    notes = @participant.notes.page(datatable_page).per(datatable_per_page).order('id desc')
    render json: {
      notes: notes.as_json,
      draw: params['draw'].to_i,
      recordsTotal: notes.count,
      recordsFiltered: notes.total_count
    }
  end

  private

  # Sort Activity Columns
  def sort_column_for_activity
    columns = %w(title points created_at)
    columns[params[:order]['0'][:column].to_i - 1]
  end

  # Sort Reward Columns
  def sort_column_for_reward
    if params[:order]['0'][:column].to_i == 0
      'rewards.name'
    else
      'reward_participants.created_at'
    end
  end

  ## Update Participant Status
  def update_status
    if @participant.update_attribute(:status, params[:status].present? ? params[:status] : @participant.status)
      response = {
          success: true,
          title: "Update user status",
          message: "User status updated successfully!"
      }
    else
      response = {
          success: false,
          title: "Update user status",
          message: "Updating user status failed!, Please try again."
      }
    end

    render json: response
  end

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
