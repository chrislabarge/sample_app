require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
  	@user = users(:chris)
  end

  test "profile display"  do
  	get user_path(@user)
  	assert_template 'users/show'
  	assert_select 'title', full_title(@user.name)
  	assert_select 'h1', text: @user.name
  	assert_select 'h1>img.gravatar' #this tests to see if the correct thing is inside the h1 tag using '>'
  	assert_match @user.microposts.count.to_s, response.body #this check the entire html page for the number of microposts, making sure the correct number is there
  	assert_select 'div.pagination'
  	@user.microposts.paginate(page: 1).each do |micropost|
  		assert_match micropost.content, response.body
  	end	
  end
end
