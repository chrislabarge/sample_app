require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	test "invalid signup information" do
 		get signup_path
 		before_count = User.count  #there is a cleaner way of doing this, below
 		post users_path, user: { name: "",
	 													 email: " user@invalid",
	 													 password:              "foo",
 														 password_confirmation: "bar"  }
 		after_count = User.count 													 
 		assert_equal before_count, after_count
 		assert_template 'users/new'		
 	 end

 	
 	 test "valid signup information" do
 		get signup_path
 		assert_difference 'User.count', 1 do
 			post_via_redirect users_path, user: { name: "Chris LaBarge",
	 														 			email: "user@yolo.com",
	 														 			password:              "password",
 															 			password_confirmation: "password"  }
 		end
 		assert_template 'users/show'		
 	 end
end
