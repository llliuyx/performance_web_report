require 'test_helper'

class PerformancesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get performances_home_url
    assert_response :success
  end

end
