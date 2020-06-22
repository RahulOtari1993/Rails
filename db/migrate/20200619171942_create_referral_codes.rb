class CreateReferralCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :referral_codes do |t|
      t.integer :user_id
      t.integer :challenge_id
      t.string :code
      t.string :short_url
      t.timestamps
    end
  end
end
