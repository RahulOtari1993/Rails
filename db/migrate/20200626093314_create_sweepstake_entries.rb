class CreateSweepstakeEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :sweepstake_entries do |t|
      t.references :reward, foreign_key: true
      t.references :participant, foreign_key: true
      t.boolean :winner, default: false
      t.timestamps
    end
  end
end
