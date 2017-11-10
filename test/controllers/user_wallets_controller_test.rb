require 'test_helper'

class UserWalletsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    post users_login_url, params: {id_nat: users(:wallet_user).id_nat, password: 'foobar'}
    @token = JSON.parse(@response.body)['auth_token']
  end

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

  	get user_wallets_show_url,  headers: {'Authorization' => @token}

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
    get user_wallets_show_cards_url, headers: {'Authorization' => @token}

    assert_response 200
  end


  test "should update wallet custom_limit" do
    user_mocked_id = User.find_by(:id_nat => users(:wallet_user).id_nat).id
    wallet = UserWallet.find_by(:user_id => user_mocked_id)
    value = wallet.limit / 2
    get user_wallets_set_custom_limit_url, params: {custom_limit: value}, headers: {'Authorization' => @token}
    assert_response 200
    assert_equal UserWallet.find(wallet.id).custom_limit, value
  end

  test "should change custom_limit value upon submit" do
    user_mocked_id = User.find_by(:id_nat => users(:wallet_user).id_nat).id
    wallet = UserWallet.find_by(:user_id => user_mocked_id)
    value = wallet.limit * 2 # twice as big as the max limit
    get user_wallets_set_custom_limit_url, params: {custom_limit: value}, headers: {'Authorization' => @token}
    assert_response 200
    assert_equal UserWallet.find(wallet.id).custom_limit, UserWallet.find(wallet.id).limit, "Custom limit should have been reduced."

    get user_wallets_set_custom_limit_url, params: {custom_limit: -value}, headers: {'Authorization' => @token}
    assert_response 200
    assert_equal UserWallet.find(wallet.id).custom_limit, 0, "Custom limit should have been set to zero."
  end
end
