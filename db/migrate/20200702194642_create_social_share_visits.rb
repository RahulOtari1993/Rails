class CreateSocialShareVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :social_share_visits do |t|
      t.integer    :referral_code_id
      t.string     :referral_code
      t.integer    :participant_id
      t.integer    :actionable_id
      t.string     :actionable_type
      t.text       :useragent,  limit: 65535
      t.string     :ipaddress,  limit: 255
      t.string     :utm_source
      t.string     :utm_medium
      t.string     :utm_termg
      t.string     :utm_content
      t.string     :utm_name
      t.timestamps
    end
  end
end
