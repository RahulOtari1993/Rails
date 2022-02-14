require "application_system_test_case"

class SportannouncementsTest < ApplicationSystemTestCase
  setup do
    @sportannouncement = sportannouncements(:one)
  end

  test "visiting the index" do
    visit sportannouncements_url
    assert_selector "h1", text: "Sportannouncements"
  end

  test "creating a Sportannouncement" do
    visit sportannouncements_url
    click_on "New Sportannouncement"

    fill_in "Msg", with: @sportannouncement.msg
    fill_in "Sport", with: @sportannouncement.sport
    click_on "Create Sportannouncement"

    assert_text "Sportannouncement was successfully created"
    click_on "Back"
  end

  test "updating a Sportannouncement" do
    visit sportannouncements_url
    click_on "Edit", match: :first

    fill_in "Msg", with: @sportannouncement.msg
    fill_in "Sport", with: @sportannouncement.sport
    click_on "Update Sportannouncement"

    assert_text "Sportannouncement was successfully updated"
    click_on "Back"
  end

  test "destroying a Sportannouncement" do
    visit sportannouncements_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sportannouncement was successfully destroyed"
  end
end
