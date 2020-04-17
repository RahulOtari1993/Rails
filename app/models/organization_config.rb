# == Schema Information
#
# Table name: organization_configs
#
#  id                   :bigint           not null, primary key
#  organization_id      :bigint
#  facebook_app_id      :string
#  facebook_app_secret  :string
#  google_client_id     :string
#  google_client_secret :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class OrganizationConfig < ApplicationRecord
  belongs_to :organization
end
