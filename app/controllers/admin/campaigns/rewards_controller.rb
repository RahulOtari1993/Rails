class Admin::Campaigns::RewardsController <  Admin::Campaigns::BaseController
  def index
    @rewards = @campaign.rewards
  end

  def generate_reward_json
    @rewards = @campaign.rewards.all
    if params[:search][:value].present?
      @reward_filtereds = @campaign.rewards.where("name LIKE ?", "%#{params[:search][:value]}%")
      render json: { rewards: @reward_filtereds.as_json, draw: params['draw'].to_i, recordsTotal: @rewards.count,
                 recordsFiltered: @reward_filtereds.count, length: params['length'].to_i  }
   else
      render json: { rewards: @rewards.as_json, draw: params['draw'].to_i, recordsTotal: @rewards.count,
                 recordsFiltered: @rewards.count, length: params['length'].to_i   }
    end
    # @rewards.to_json
    # @rewards[]=nil
    # @rewards["total"] = @rewards.count
  end

  def new
    @reward = @campaign.rewards.new
    @reward_filter = @reward.reward_filters.build
  end

  def create
   @reward = @campaign.rewards.new(reward_params)
    #update the start param
    @reward.start = Chronic.parse(params[:reward][:start]) || @reward.start rescue @reward.start
    #update the finish 
    @reward.finish = Chronic.parse(params[:reward][:finish]) || @reward.finish  rescue @reward.finish
    @reward.feature = params[:reward][:feature].nil? ? false : (params[:reward][:feature] == "on")
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
      @reward.reward_users.each do |user_reward|

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

  def ajax_user
    @reward = @campaign.rewards.find_by(:id => params[:reward_id])
  end

  def edit 
    @reward = @campaign.rewards.find_by(:id => params[:id])
  end

  def update
    @reward = @campaign.rewards.find_by(:id => params[:id])
    if @reward.update_attributes(reward_params)
      redirect_to admin_campaign_rewards_path, notice: 'Reward successfully updated'
    else
      render :edit
    end
  end

  def ajax_coupon_form
    @reward = @campaign.rewards.find_by(:id => params[:reward_id])
    @coupons = @reward.coupons
    @coupon = @reward.coupons.new
  end

  def create_coupon
    coupon_array = params[:coupon][:code].split(',')
    @reward = @campaign.rewards.find_by(:id => params[:reward_id])
    coupon_array.each do |c|
      coupon = Coupon.new
      coupon.reward_id = @reward.id
      coupon.code = c
      coupon.save
    end
    # @coupon = @reward.coupons.new(coupon_params)
    # if @coupon.save
    redirect_to admin_campaign_rewards_path, notice: 'Coupon successfully created'
    # end
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
      format.html { }
      format.json {  }
    else
      flash[:notice] = "Post failed to delete."
      format.html { }
      format.json {  }
    end
  end
    # @reward_filter.destroy
    # redirect_to edit_campaign_reward_path(@reward), notice: 'Active Segment deleted.'
  end

  private

  def reward_params
    params.require(:reward).permit(:name, :limit, :threshold, :description, :image_file_name, :image_file_size,
                           :image,:image_content_type, :selection, :start, :finish, :feature, :points,
                            :is_active, :redemption_details, :description_details, :terms_conditions,
                            :sweepstake_entry, reward_filters_attributes: [:id, :reward_id, :reward_condition,
                            :reward_value, :reward_event])
  end
  def coupon_params
    params.require(:coupon).permit!
  end
  ##coupon_pon).permit!
end