class CreateChallengeFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_filters do |t|
      t.references :challenge
      t.string :challenge_event
      t.string :challenge_condition
      t.string :challenge_value

      t.timestamps
    end
  end
end
