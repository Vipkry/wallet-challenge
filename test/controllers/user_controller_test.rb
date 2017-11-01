require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  
  test "should get index" do
    get user_index_url, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
    	post user_create_url, params: {user: { name: 'Kerrigan', password: '1234567890', id_nat: '17915160419' }}
    end

    assert_response 201
  end

  test "wont permit blank password" do
  	post user_create_url, params: {user: { name: 'Kerrigan', password: '', id_nat: '17915160419' }}

  	assert_response 422
  end
end
