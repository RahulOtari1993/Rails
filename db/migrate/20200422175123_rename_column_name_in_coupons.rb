class RenameColumnNameInCoupons < ActiveRecord::Migration[5.2]
  def change
  	rename_column :coupons, :reward_user_id, :reward_participant_id
  end
end
