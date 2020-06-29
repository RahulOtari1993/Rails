class RenameReferralCodesColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :referral_codes, :user_id, :participant_id
  end
end
