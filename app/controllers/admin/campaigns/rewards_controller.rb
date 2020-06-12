class Admin::Campaigns::RewardsController < Admin::Campaigns::BaseController
  before_action :set_reward, only: [:edit, :update]
  before_action :build_params, only: [:create, :update]
  require 'mini_magick'


  def index
    @rewards = @campaign.rewards
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

  def new
    @reward = @campaign.rewards.new
    @reward_filter = @reward.reward_filters.build
  end

  def create
    @reward = @campaign.rewards.new(reward_params)

    ## Manage Reward Tags
    tags_association

    if @reward.save
      redirect_to admin_campaign_rewards_path, notice: 'Reward successfully created'
    else
      render :new, notice: "Error creating rewards"
    end
  end


  def reward_export
    #grab the reward
    @reward = Reward.find(params[:reward_id])
    #generate the csv of the results
    results = CSV.generate do |csv|
      #generate the header
      csv << [
          "first_name",
          "family_name",
          "email",
          "earned_date"
      ]

      #set the results
      @reward.reward_participants.each do |user_reward|
        csv << [
            user_reward.user.first_name,
            user_reward.user.full_name,
            user_reward.user.email,
            user_reward.created_at
        ]
      end
    end

    #send down the results to the user
    return send_data results, type: "text/csv; charset=utf-8; header=present", disposition: "attachment; filename=contacts.csv", filename: "contacts.csv"
  end

  def download_csv_popup
    @reward = @campaign.rewards.find_by(:id => params[:reward_id])
  end

  def edit
    # @reward = @campaign.rewards.find_by(:id => params[:id])
  end

  def update
    respond_to do |format|
      previous_segments = @reward.reward_filters.pluck(:id)
      previous_rules = @reward.reward_rules.pluck(:id)
      removed_segments = previous_segments - @available_segments
      removed_rules = previous_rules - @available_rules

      ## Manage Tags for a Reward
      tags_association

      if @reward.update(reward_params)
        ## Remove Deleted User Segments & Reward Rules from a Reward
        @reward.reward_filters.where(id: removed_segments).delete_all if removed_segments.present?
        @reward.reward_rules.where(id: removed_rules).delete_all if removed_rules.present?

        format.html { redirect_to admin_campaign_rewards_path(@campaign), notice: 'Reward was successfully updated.' }
        format.json { render :edit, status: :updated }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def coupon_form
    @reward = @campaign.rewards.find_by(:id => params[:reward_id])
    @coupons = @reward.coupons
    @coupon = @reward.coupons.new
  end

  def create_coupon
    coupon_array = params[:coupon][:code].split(',')
    @reward = @campaign.rewards.find_by(:id => params[:reward_id])
    coupon_array.each do |code|
      coupon = Coupon.new
      coupon.reward_id = @reward.id
      coupon.code = code
      coupon.save
    end
    redirect_to admin_campaign_rewards_path, notice: 'Coupon successfully created'
  end

  def destroy
    @reward = @campaign.rewards.find_by(:id)
    @reward.destroy
    redirect_to :back
  end

  def delete_reward_filter
    # @reward = @campaign.reward.find_by(:id=>params[:reward_id])
    @reward_filter = RewardFilter.find_by(:id => params[:id])
    respond_to do |format|
      if @reward_filter.destroy
        format.html {}
        format.json {}
      else
        flash[:notice] = "Post failed to delete."
        format.html {}
        format.json {}
      end
    end
    # @reward_filter.destroy
    # redirect_to edit_campaign_reward_path(@reward), notice: 'Active Segment deleted.'
  end

  private

  def reward_params
    return_params = params.require(:reward).permit(:name, :limit, :threshold, :description, :image_file_name, :image_file_size,
                                                   :image, :image_content_type, :selection, :start, :finish, :feature, :points,
                                                   :is_active, :redemption_details, :description_details, :terms_conditions, :filter_applied, :filter_type,
                                                   :sweepstake_entry, reward_filters_attributes: [:id, :reward_id, :reward_condition,
                                                                                                  :reward_value, :reward_event],
                                                   reward_rules_attributes: [:id, :reward_id, :rule_type, :rule_condition, :rule_value])
    return_params[:start] = Chronic.parse(params[:reward][:start]).beginning_of_day
    return_params[:finish] = Chronic.parse(params[:reward][:finish]).end_of_day

    return_params
  end

  ## Build Nested Attributes Params for User Segments
  def build_params
    @available_segments = []
    @available_rules = []

    if params[:reward].has_key?('reward_filters_attributes')
      new_params = []

      cust_params = params[:reward][:reward_filters_attributes]
      cust_params.each do |key, c_param|
        filter_data = {
            reward_event: c_param[:reward_event],
            reward_condition: c_param[:reward_condition],
            reward_value: c_param["reward_value_#{c_param[:reward_event]}"]
        }

        if c_param.has_key?('id')
          filter_data[:id] = c_param[:id]
          @available_segments.push(c_param[:id].to_i)
        end

        new_params.push(filter_data)
      end

      params[:reward][:reward_filters_attributes] = new_params
    end
    if params[:reward].has_key?('reward_rules_attributes')
      new_params = []

      cust_params = params[:reward][:reward_rules_attributes]
      cust_params.each do |key, c_param|
        filter_data = {
            rule_type: c_param[:reward_rule],
            rule_condition: c_param[:rule_condition],
            rule_value: c_param["#{c_param[:reward_rule]}_rule_value"]
        }

        if c_param.has_key?('id')
          filter_data[:id] = c_param[:id]
          @available_rules.push(c_param[:id].to_i)
        end

        new_params.push(filter_data)
      end
      params[:reward][:reward_rules_attributes] = new_params
    end
  end

  #coupon params
  def coupon_params
    params.require(:coupon).permit!
  end

  def search_columns
    %w(name)
  end

  def sort_column
    columns = %w(name start finish)
    columns[params[:order]['0'][:column].to_i - 1]
  end

  ## Assign/Remove Tags to a Challenge
  def tags_association
    tags = params[:reward][:tags].reject { |c| c.empty? } if params[:reward].has_key?('tags')
    removed_tags = @reward.tag_list - tags

    @reward.tag_list.remove(removed_tags.join(', '), parse: true) if removed_tags.present?
    @reward.tag_list.add(tags.join(', '), parse: true) if tags.present?
  end

  ## Set reward
  def set_reward
    @reward = @campaign.rewards.find_by(:id => params[:id]) rescue nil
  end
end