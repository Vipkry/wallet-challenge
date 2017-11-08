require 'test_helper'

class CardsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    post users_login_url, params: {id_nat: users(:wallet_user).id_nat, password: 'foobar'}
    @token = JSON.parse(@response.body)['auth_token']

    Card.create!(:user_wallet_id => users(:wallet_user).user_wallet.id, :limit => 1000, :number => '123123123')
  end

  test "should create valid card" do
  	card = cards(:real)
    initial_limit = UserWallet.find_by(:user_id => users(:wallet_user).id).limit
  	post cards_create_url, params: {card: { number: card.number,
                    											 cvv: card.cvv, 
                    											 expiration_year: '2020', 
                    											 expiration_month: '08', 
                    											 limit: card.limit, 
                    											 name: card.name, 
  											                   name_written: card.name_written}},
						               headers: {'Authorization' => @token}
    final_limit = UserWallet.find_by(:user_id => users(:wallet_user).id).limit
  	assert_response 201, "Didn't create the card successfully."
  	assert_not_nil Card.last.user_wallet_id, "Didn't set the wallet properly."
    assert initial_limit < final_limit, "Wallet Limit didn't update correctly."
  end

	test "should not authorize" do
		card = cards(:real)
		post cards_create_url params: {card: { number: card.number,
    											 cvv: card.cvv, 
    											 expiration_year: '2020', 
    											 expiration_month: '08', 
    											 limit: card.limit, 
    											 name: card.name, 
    											 name_written: card.name_written}}
    assert_response 401, "Authorized action when it shouldn't."																				 
	end

  test "should destroy card and update wallet" do
    
    
    assert_difference("UserWallet.find(users(:wallet_user).user_wallet.id).limit", -users(:wallet_user).user_wallet.cards.first.limit) do
      assert_difference('Card.count', -1) do
        delete cards_url, params: {id: users(:wallet_user).user_wallet.cards.first.id}, headers: {'Authorization' => @token}
      end
    end



    assert_response 204
  end


end
