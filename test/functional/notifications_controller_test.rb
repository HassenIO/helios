require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  test "should get process" do
    get :process
    assert_response :success
  end

end
