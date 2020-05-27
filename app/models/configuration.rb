# == Schema Information
#
# Table name: configurations
#
#  id                   :bigint           not null, primary key
#  facebook_app_id      :string
#  facebook_app_secret  :string
#  google_client_id     :string
#  google_client_secret :string
#  twitter_app_id       :string
#  twitter_app_secret   :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null

class Configuration < ApplicationRecord
end
