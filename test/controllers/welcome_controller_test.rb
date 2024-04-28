require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get welcome_top_url
    assert_response :success
  end
end
