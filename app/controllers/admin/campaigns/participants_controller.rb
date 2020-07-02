class Admin::Campaigns::ParticipantsController < Admin::Campaigns::BaseController
  before_action :set_participant, only: [:show, :remove_tag, :add_tag, :add_note, :update_status]

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
    gender_element_count = []
    age_element_count = []
    completed_challenges_element_count = []
    connected_platform_element_count = [5] # Test value for twitter
    participants = @campaign.participants 

    # For Age breakdown
    age_element_count << Participant.by_age1(@campaign.participants)
    age_element_count << Participant.by_age2(@campaign.participants)
    age_element_count << Participant.by_age3(@campaign.participants)
    age_element_count << Participant.by_age4(@campaign.participants)
    age_element_count << Participant.by_age5(@campaign.participants)
    age_element_count << Participant.by_age6(@campaign.participants)

    # For Gender breakdown
    gender_element_count << Participant.male_count(participants)
    gender_element_count << Participant.female_count(participants)
    gender_element_count << Participant.other_count(participants)

    # For Completed Challenges / Platform
    completed_challenges_element_count << @campaign.challenges.where(challenge_type: 'share', parameters: 'twitter').count
    completed_challenges_element_count << @campaign.challenges.where(challenge_type: 'share', parameters: 'facebook').count
    completed_challenges_element_count << @campaign.challenges.where(challenge_type: 'share', parameters: 'google').count

    # For Connected Platforms
    connected_platform_element_count << Participant.connected_platform_with_facebook(@campaign.challenges)
    connected_platform_element_count << Participant.connected_platform_with_google(@campaign.challenges)
    render json: {
      genderElementCount: gender_element_count,
      ageElementCount: age_element_count,
      completedChallengesElementCount: completed_challenges_element_count,
      connectedPlatformElementCount: connected_platform_element_count
    }
  end

  private
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
