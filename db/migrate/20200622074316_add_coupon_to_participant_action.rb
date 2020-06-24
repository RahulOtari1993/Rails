class AddCouponToParticipantAction < ActiveRecord::Migration[5.2]
  def change
    add_column :participant_actions, :coupon, :string
  end
end
