class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.references :organization, foreign_key: true
      t.string :name, null: false
      t.string :domain, null: false
      t.string :twitter
      t.text :rules
      t.text :privacy
      t.text :terms
      t.text :contact_us
      t.string :faq_title
      t.text :faq_content
      t.string :prizes_title
      t.text :general_content
      t.string :how_to_earn_title
      t.text :how_to_earn_content
      t.text :css
      t.text :seo
      t.boolean :is_active, default: true
      t.text :template
      t.boolean :templated

      t.timestamps
    end
  end
end
