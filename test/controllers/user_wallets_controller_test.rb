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
  	credit = aux_response['credit'] if aux_response

  	assert_response 200
  	assert_not_nil limit
  	assert_not_nil custom_limit
  	assert_not_empty limit
  	assert_not_empty custom_limit
  	assert_not_nil credit
  	assert_not_empty credit
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
    assert_equal UserWallet.find(wallet.id).custom_limit, UserWallet.find(wallet.id).limit, "Custom limit should have been set to the max limit."
  end

  test "should have ok at spend" do
    # setup
    card = cards(:real)
    @card = Card.create!(number: card.number,
                 cvv: card.cvv,
                 expiration_year: '2020', 
                 expiration_month: '08', 
                 due_day: '20',
                 limit: card.limit,
                 name: card.name,
                 name_written: card.name_written,
                 user_wallet_id: users(:wallet_user).user_wallet.id)

    assert_difference("Card.all.sum(:spent)", +100) do
      get user_wallets_spend_url, params: {ammount: 100}, headers: {'Authorization' => @token}
      assert_response 200
    end 

    travel_to(Date.new(Date.today.year, 2, 28)) do #testing feb 28
      post users_login_url, params: {id_nat: users(:wallet_user).id_nat, password: 'foobar'}
      token = JSON.parse(@response.body)['auth_token']

      assert_difference("Card.all.sum(:spent)", +100) do
        get user_wallets_spend_url, params: {ammount: 100}, headers: {'Authorization' => token}
        assert_response 200
      end     
    end
  end

  test "should not have ok at spend" do
    # setup
    card = cards(:real)
    @card = Card.create!(number: card.number,
                 cvv: card.cvv,
                 expiration_year: '2020', 
                 expiration_month: '08', 
                 due_day: '20',
                 limit: card.limit,
                 name: card.name,
                 name_written: card.name_written,
                 user_wallet_id: users(:wallet_user).user_wallet.id)
    
    get user_wallets_spend_url, params: {ammount: @card.limit + 1}, headers: {'Authorization' => @token}
    assert_response 400

    get user_wallets_spend_url, headers: {'Authorization' => @token}
    assert_response 400
      
    get user_wallets_spend_url, params: {ammount: @card.limit + 1}
    assert_response 401
   
  end
end
