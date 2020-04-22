class CreateParticipantAccountConnects < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_account_connects do |t|
      t.references :participant 
      t.string :email
      t.string :token
      t.string :platform
      t.timestamps
    end
  end
end
