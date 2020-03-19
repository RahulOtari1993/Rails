# == Schema Information
#
# Table name: organizations
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  sub_domain    :string           not null
#  admin_user_id :bigint           not null
#  is_active     :boolean          default("true"), not null
#  is_deleted    :boolean          default("false"), not null
#  deleted_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Organization < ApplicationRecord
  ## Associations
  has_many :users, dependent: :destroy
  has_many :organization_admins, dependent: :destroy
  has_many :campaigns, dependent: :destroy

  ## Validations
  validates :name, :sub_domain, :admin_user_id, presence: true
  validates :sub_domain, uniqueness: true

  ## Scope
  default_scope { where(is_deleted: false) }
  scope :active, -> { where(is_active: true) }

end

# rails g model Rewards campaign:references name:string limit:integer threshold:integer description:text image_file_name:string image_file_size:decimal image_content_type:string selection:string start:datetime finish:datetime feature:boolean points:integer redeption_details:text description_details:text terms_conditions:text sweepstake_entry:integer

# rails g model Campaign organization:references name:string domain:string twitter:string rules:text privacy:text terms:text contact_us:text faq_title:string faq_content:string prizes_title:string general_content:text how_to_earn_title:string how_to_earn_content:text css:text seo:text is_active:boolean template:text templated:boolean