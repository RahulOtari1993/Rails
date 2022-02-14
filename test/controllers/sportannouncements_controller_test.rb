require 'test_helper'

class SportannouncementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sportannouncement = sportannouncements(:one)
  end

  test "should get index" do
    get sportannouncements_url
    assert_response :success
  end

  test "should get new" do
    get new_sportannouncement_url
    assert_response :success
  end

  test "should create sportannouncement" do
    assert_difference('Sportannouncement.count') do
      post sportannouncements_url, params: { sportannouncement: { msg: @sportannouncement.msg, sport: @sportannouncement.sport } }
    end

    assert_redirected_to sportannouncement_url(Sportannouncement.last)
  end

  test "should show sportannouncement" do
    get sportannouncement_url(@sportannouncement)
    assert_response :success
  end

  test "should get edit" do
    get edit_sportannouncement_url(@sportannouncement)
    assert_response :success
  end

  test "should update sportannouncement" do
    patch sportannouncement_url(@sportannouncement), params: { sportannouncement: { msg: @sportannouncement.msg, sport: @sportannouncement.sport } }
    assert_redirected_to sportannouncement_url(@sportannouncement)
  end

  test "should destroy sportannouncement" do
    assert_difference('Sportannouncement.count', -1) do
      delete sportannouncement_url(@sportannouncement)
    end

    assert_redirected_to sportannouncements_url
  end
end
