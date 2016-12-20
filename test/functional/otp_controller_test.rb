require 'test_helper'

class OtpControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
