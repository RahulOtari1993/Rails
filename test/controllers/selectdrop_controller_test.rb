require 'test_helper'

class SelectdropControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get selectdrop_index_url
    assert_response :success
  end

end
