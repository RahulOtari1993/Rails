class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.references :reward, foreign_key: true
      t.integer :reward_user_id
      # t.string :name
      t.string :code

      t.timestamps
    end
  end
end
