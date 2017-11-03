require 'test_helper'

class UserWalletControllerTest < ActionDispatch::IntegrationTest
  
  test "should not authorize" do

  	post user_wallet_show_url, params: { user_id: users(:wallet_user).id, token: nil}
  	assert_response 401

  	post user_wallet_show_url, params: { user_id: nil, token: 'random'}
  	assert_response 401

  	post user_wallet_show_url, params: { user_id: nil, token: nil}
  	assert_response 401

  	post user_wallet_show_url, params: { user_id: 'foo', token: 'bar'}
  	assert_response 401
  end

  test "should show wallet params" do
  	post user_wallet_show_url, params: { user_id: users(:wallet_user).id, token: users(:wallet_user).login_token}

  	aux_response = JSON.parse(@response.body)
  	limit = aux_response['limit']
  	custom_limit = aux_response['custom_limit']
  	#credit_available = aux_response['credit_available']


  	assert_response 200
  	assert_not_nil limit
  	assert_not_nil custom_limit
  	assert_not_empty limit
  	assert_not_empty custom_limit

  	#assert_not_nil credit_available
  	#assert_not_empty credit_available
  end
end
