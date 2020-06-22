class AddUniqueIndexToReferralCode < ActiveRecord::Migration[5.2]
  def change
    add_index :referral_codes, :code, unique: true
    add_index :referral_codes, :challenge_id
    add_index :referral_codes, :user_id
  end
end
