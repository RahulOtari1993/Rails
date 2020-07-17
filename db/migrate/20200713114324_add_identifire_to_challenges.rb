class AddIdentifireToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :identifier, :string

    ## Update Existing Challenges with Unique Identifier
    Challenge.all.each do |challenge|
      challenge.update_attribute('identifier', Challenge.get_identifier)
    end
  end
end
