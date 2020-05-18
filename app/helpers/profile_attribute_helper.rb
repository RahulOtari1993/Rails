module ProfileAttributeHelper

  ## Return Profile Attribute Field Type Options
  def profile_attribute_field_types
    ProfileAttribute::field_types.map{|k,v| [k, v]}
  end
end
