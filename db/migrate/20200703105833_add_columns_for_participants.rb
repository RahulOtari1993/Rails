class AddColumnsForParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :job_position, :string
    add_column :participants, :job_company_name, :string
    add_column :participants, :job_industry, :string
  end
end
