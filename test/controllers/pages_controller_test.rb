require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_template 'pages/home'
    assert_response :success
  end

  test "should get about" do
  	get :about
  	assert_template 'pages/about'
  	assert_response :success
  end

end
