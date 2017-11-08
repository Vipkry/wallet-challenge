require 'test_helper'

class UserWalletsControllerTest < ActionDispatch::IntegrationTest
  
  test "should not authorize" do

  	get user_wallets_show_url, params: { user_id: users(:wallet_user).id }, headers: {'Authorization' => 'someToken'}
  	assert_response 401

  	get user_wallets_show_url, params: { user_id: nil}, headers: {'Authorization' => 'someToken'}
  	assert_response 401

  	get user_wallets_show_url, params: { user_id: nil}, headers: {'Authorization' => ''}
  	assert_response 401

  	get user_wallets_show_url, params: { user_id: 'foo'}, headers: {'Authorization' => 'someToken'}
  	assert_response 401

  end

  test "should show wallet params" do
    
    post users_login_url, params: {id_nat: users(:wallet_user).id_nat, password: 'foobar'}
    token = JSON.parse(@response.body)['auth_token']

    assert_response 200 , "Expected successfull login."

  	get user_wallets_show_url,  headers: {'Authorization' => token}

  	aux_response = JSON.parse(@response.body)
  	limit = aux_response['limit'] if aux_response
  	custom_limit = aux_response['custom_limit'] if aux_response
  	#credit_available = aux_response['credit_available']

  	assert_response 200
  	assert_not_nil limit
  	assert_not_nil custom_limit
  	assert_not_empty limit
  	assert_not_empty custom_limit

  	#assert_not_nil credit_available
  	#assert_not_empty credit_available
  end

  test "should get cards" do

    post users_login_url, params: {id_nat: users(:wallet_user).id_nat, password: 'foobar'}
    token = JSON.parse(@response.body)['auth_token']

    assert_response 200, "Expected successfull login."

    get user_wallets_show_cards_url, headers: {'Authorization' => token}

    assert_response 200

  end

end
