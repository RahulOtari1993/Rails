require 'test_helper'

class DefaultControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get default_dashboard_url
    assert_response :success
  end

end
