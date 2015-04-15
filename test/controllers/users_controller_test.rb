require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new signup page" do
    get :new
    assert_response :success
  	assert_select "title", "Sign Up | Ruby on Rails Tutorial Sample App"
  end

end
