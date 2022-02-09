require 'test_helper'

class SportMailerTest < ActionMailer::TestCase
  test "sport_created" do
    mail = SportMailer.sport_created
    assert_equal "Sport created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
