class CreateSocialChallengePostVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :social_challenge_post_visits do |t|

      t.references :challenge, foreign_key: true
      t.references :participant, foreign_key: true
      t.integer :network_page_post_attachment_id
      t.integer :points

      t.timestamps
    end
  end
end
