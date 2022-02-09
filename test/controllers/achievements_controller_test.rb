require 'test_helper'

class AchievementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @achievement = achievements(:one)
  end

  test "should get index" do
    get achievements_url
    assert_response :success
  end

  test "should get new" do
    get new_achievement_url
    assert_response :success
  end

  test "should create achievement" do
    assert_difference('Achievement.count') do
      post achievements_url, params: { achievement: { award: @achievement.award, medal: @achievement.medal } }
    end

    assert_redirected_to achievement_url(Achievement.last)
  end

  test "should show achievement" do
    get achievement_url(@achievement)
    assert_response :success
  end

  test "should get edit" do
    get edit_achievement_url(@achievement)
    assert_response :success
  end

  test "should update achievement" do
    patch achievement_url(@achievement), params: { achievement: { award: @achievement.award, medal: @achievement.medal } }
    assert_redirected_to achievement_url(@achievement)
  end

  test "should destroy achievement" do
    assert_difference('Achievement.count', -1) do
      delete achievement_url(@achievement)
    end

    assert_redirected_to achievements_url
  end
end
