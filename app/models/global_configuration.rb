# == Schema Information
#
# Table name: global_configurations
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
#

class GlobalConfiguration < ApplicationRecord
  ## Validations
  validates_presence_of :facebook_app_id, :facebook_app_secret, :google_client_id, :google_client_secret, :twitter_app_id, :twitter_app_secret
end
