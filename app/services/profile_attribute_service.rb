class ProfileAttributeService
  def initialize(campaign_id)
    @campaign_id = campaign_id
  end

  ## Create Profile Attribute Records
  def process_records
    details = generate_default_data
    details.each do |record|
      ProfileAttribute.create(record)
    end
  end

  ## Generate Default Hash for Profile Attributes
  def generate_default_data
    [
        {
            attribute_name: 'birth_date',
            display_name: 'Birth Date',
            field_type: 'date',
            is_active: true,
            is_custom: false,
            campaign_id: @campaign_id

        },
        {
            attribute_name: 'gender',
            display_name: 'Gender',
            field_type: 'radio_button',
            is_active: true,
            is_custom: false,
            campaign_id: @campaign_id

        },
        {
            attribute_name: 'phone',
            display_name: 'Phone',
            field_type: 'string',
            is_active: true,
            is_custom: false,
            campaign_id: @campaign_id

        },
        {
            attribute_name: 'city',
            display_name: 'City',
            field_type: 'string',
            is_active: true,
            is_custom: false,
            campaign_id: @campaign_id

        },
        {
            attribute_name: 'state',
            display_name: 'State',
            field_type: 'string',
            is_active: true,
            is_custom: false,
            campaign_id: @campaign_id

        },
        {
            attribute_name: 'postal',
            display_name: 'Postal Code',
            field_type: 'string',
            is_active: true,
            is_custom: false,
            campaign_id: @campaign_id

        },
        {
            attribute_name: 'address_1',
            display_name: 'Address Line 1',
            field_type: 'string',
            is_active: true,
            is_custom: false,
            campaign_id: @campaign_id

        },
        {
            attribute_name: 'address_2',
            display_name: 'Address Line 2',
            field_type: 'string',
            is_active: true,
            is_custom: false,
            campaign_id: @campaign_id

        },
        {
            attribute_name: 'bio',
            display_name: 'Bio Data',
            field_type: 'text_area',
            is_active: true,
            is_custom: false,
            campaign_id: @campaign_id

        },
        {
            attribute_name: 'affiliation',
            display_name: 'Affiliation',
            field_type: 'check_box',
            is_active: true,
            is_custom: false,
            campaign_id: @campaign_id

        }
    ]
  end
end