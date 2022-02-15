require "application_system_test_case"

class PlayersTest < ApplicationSystemTestCase
  setup do
    @player = players(:one)
  end

  test "visiting the index" do
    visit players_url
    assert_selector "h1", text: "Players"
  end

  test "creating a Player" do
    visit players_url
    click_on "New Player"

    fill_in "Gender", with: @player.gender
    fill_in "Phone", with: @player.phone
    fill_in "Player city", with: @player.player_city
    fill_in "Player country", with: @player.player_country
    fill_in "Player name", with: @player.player_name
    fill_in "Player state", with: @player.player_state
    click_on "Create Player"

    assert_text "Player was successfully created"
    click_on "Back"
  end

  test "updating a Player" do
    visit players_url
    click_on "Edit", match: :first

    fill_in "Gender", with: @player.gender
    fill_in "Phone", with: @player.phone
    fill_in "Player city", with: @player.player_city
    fill_in "Player country", with: @player.player_country
    fill_in "Player name", with: @player.player_name
    fill_in "Player state", with: @player.player_state
    click_on "Update Player"

    assert_text "Player was successfully updated"
    click_on "Back"
  end

  test "destroying a Player" do
    visit players_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Player was successfully destroyed"
  end
end
