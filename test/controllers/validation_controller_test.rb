require 'test_helper'

class ValidationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get validation_index_url
    assert_response :success
  end

end
