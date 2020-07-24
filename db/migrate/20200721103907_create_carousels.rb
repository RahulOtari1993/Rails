class CreateCarousels < ActiveRecord::Migration[5.2]
  def change
    create_table :carousels do |t|
      t.string :title
      t.text :description
      t.string :button_text
      t.string :link
      t.string :image
      t.references :campaign, foreign_key: true

      t.timestamps
    end
  end
end
