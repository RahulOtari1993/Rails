class Participants::ParticipantAccountsController < ApplicationController
  before_action :authenticate_participant!

  ## Fetch Details of reward
  def details_form
    @email_settings = @campaign.email_settings
    @participant_actions = current_participant.participant_actions
  end

  def update_profile_details
    participant_profile_params = participant_params.merge!(onboarding_question_params)
    if current_participant.update(participant_params)
      ## Commenting this code , As removed from UI
      # profile_attribute = @campaign.profile_attributes.where(attribute_name: "affiliation").first
      # unless (params[:affiliation_types].blank? || profile_attribute.blank?)
      #   ## delete existing partcipant profiles
      #   current_participant.participant_profiles.where(profile_attribute_id: @campaign.profile_attributes.where(attribute_name: 'affiliation').first.id).destroy_all
      #
      #   ## create new selected participant profiles
      #   params[:affiliation_types].each do |item|
      #     participant_profile = current_participant.participant_profiles.new(profile_attribute_id: profile_attribute.id, value: item)
      #     participant_profile.save
      #   end
      # end
    end
  end

  ## Disconnect Existing Connected Social Media Account
  def disconnect
    participant = current_participant

    if params[:connection_type] == 'facebook'
      participant.facebook_uid = nil
      participant.facebook_token = nil
      participant.facebook_expires_at = nil
    elsif params[:connection_type] == 'twitter'
      participant.twitter_uid = nil
      participant.twitter_token = nil
      participant.twitter_secret = nil
    end

    if participant.save(:validate => false)
      redirect_to root_path, notice: "#{params[:connection_type].humanize} account disconnected successfully"
    else
      redirect_to root_path, alert: "#{params[:connection_type].humanize} account disconnect failed"
    end
  end

  def fetch_activities
    actions = current_participant.participant_actions
    participant_actions = actions
    participant_actions = participant_actions.order(sort_column_for_activity.to_sym => datatable_sort_direction.to_sym) unless sort_column_for_activity.nil?
    participant_actions = participant_actions.page(datatable_page).per(datatable_per_page)

    render json: {
        participant_actions: participant_actions.as_json,
        draw: params['draw'].to_i,
        recordsTotal: actions.count,
        recordsFiltered: actions.count
    }
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def participant_params
    params.require(:participant).permit(:first_name, :last_name, :address_1,
                                        :address_2, :city, :state, :postal, :country, :phone, :avatar,
                                        :home_phone, :work_phone, :job_position, :job_company_name, :job_industry, :email_setting_id)
  end

  ## Manage & Build Extended Profile Question Params
  def onboarding_question_params
    birthdate = ''
    age = 0

    profile_params = {participant_profiles_attributes: []}
    params[:questions].each do |key, question|
      if question[:is_custom] == 'true'
        if question[:answer].instance_of? Array
          question[:answer].each do |opt|
            profile_params[:participant_profiles_attributes].push({
                                                                      profile_attribute_id: question[:profile_attribute_id],
                                                                      value: opt
                                                                  })
          end
        else
          profile_params[:participant_profiles_attributes].push({
                                                                    profile_attribute_id: question[:profile_attribute_id],
                                                                    value: question[:answer]
                                                                })
        end
      else
        if question[:answer].instance_of? Array
          question[:answer].each do |opt|
            profile_params[question[:attribute_name]] = opt
          end
        else
          profile_params[question[:attribute_name]] = question[:answer]
          birthdate = question[:answer] if question[:attribute_name] == 'birth_date' && question[:answer].present?
          age = question[:answer].to_i if question[:attribute_name] == 'age' && question[:answer].present?
        end
      end
    end

    ## Age Calculation
    attributes = params['questions'].values.map { |x| x[:attribute_name] }
    if (!attributes.include?('age') || age == '' || age == 0) && (attributes.include?('birth_date') && birthdate != '')
      profile_params['age'] = Participant.calculate_age(birthdate)
    end

    profile_params
  end


  # Sort Activity Columns
  def sort_column_for_activity
    columns = %w(title points created_at)
    columns[params[:order]['0'][:column].to_i]
  end

  ## Returns Datatable Page Number
  def datatable_page
    params[:start].to_i / datatable_per_page + 1
  end

  ## Returns Datatable Per Page Length Count
  def datatable_per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  ## Returns Datatable Sorting Direction
  def datatable_sort_direction
    params[:order]['0'][:dir] == 'desc' ? 'desc' : 'asc'
  end

end
