class UpdateIsActiveFieldOfRewards < ActiveRecord::Migration[5.2]
  def change
    Reward.update_all(is_active: true)
  end
end
