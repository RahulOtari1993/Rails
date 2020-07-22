# == Schema Information
#
# Table name: profile_attributes
#
#  id             :bigint           not null, primary key
#  campaign_id    :bigint
#  attribute_name :string
#  display_name   :string
#  field_type     :integer
#  is_active      :boolean          default(TRUE)
#  is_custom      :boolean          default(TRUE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class ProfileAttribute < ApplicationRecord

  ## Associations
  belongs_to :campaign
  has_many :participant_profiles, dependent: :destroy

  ## ENUM
  enum field_type: {string: 0, text_area: 1, boolean: 2, date: 3, time: 4, date_time: 5, number: 6, decimal: 7,
                    radio_button: 8, check_box: 9, dropdown: 10} ## , image_radio_button: 11, image_check_box: 12

  ## Scopes
  scope :active, -> { where(is_active: true) }

  ## Validations
  validates :attribute_name, :display_name, :field_type, presence: true
  validates_uniqueness_of :attribute_name, :scope => :campaign_id
end
