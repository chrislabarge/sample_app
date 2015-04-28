require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	def setup
		ActionMailer::Base.deliveries.clear
	end

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
 			post users_path, user: { name: "Chris LaBarge",
	 														 email: "user@yolo.com",
	 														 password:              "password",
 															 password_confirmation: "password"  }
 	
 		end
 		assert_equal 2, ActionMailer::Base.deliveries.size #I'm thinking it sends out two including the text version
 		user = assigns(:user)
 		assert_not user.activated?
 		# Try to log in before activation
 		log_in_as(user)
 		assert_not is_logged_in?
 		# Invalid activation token
 		get edit_account_activation_path("invalid token")
 		assert_not is_logged_in?
		#Right token, wrong email
 		get edit_account_activation_path(user.activation_token, email:'wrong')
 		assert_not is_logged_in?
 		#Activate account correctly
 		get edit_account_activation_path(user.activation_token, email: user.email)
 		assert user.reload.activated?
 		follow_redirect!
 		assert_template 'users/show'
 		
 		
 		assert_not is_logged_in? #test helper this is still failing
 	 end
end
