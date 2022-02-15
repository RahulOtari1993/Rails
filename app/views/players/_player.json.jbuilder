json.extract! player, :id, :player_name, :player_city, :player_state, :player_country, :phone, :gender, :created_at, :updated_at
json.url player_url(player, format: :json)
