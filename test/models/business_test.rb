# == Schema Information
#
# Table name: businesses
#
#  id            :bigint           not null, primary key
#  name          :string
#  address       :string
#  logo          :string
#  working_hours :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'test_helper'

class BusinessTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
