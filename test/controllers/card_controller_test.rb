require 'test_helper'

class CardControllerTest < ActionDispatch::IntegrationTest
  
  test "should create valid card" do
  	post user_login_url, params: {id_nat: users(:wallet_user).id_nat, password: 'foobar'}
    token = JSON.parse(@response.body)['auth_token']

    if token
    	card = cards(:real)
      user = User.find_by(:id_nat => users(:wallet_user).id_nat)
      initial_limit = UserWallet.find_by(:user_id => user.id).limit
    	post card_create_url, params: {card: { number: card.number,
                      											 cvv: card.cvv, 
                      											 expiration_year: '2020', 
                      											 expiration_month: '08', 
                      											 limit: card.limit, 
                      											 name: card.name, 
    											                   name_written: card.name_written}},
							               headers: {'Authorization' => token}
      final_limit = UserWallet.find_by(:user_id => user.id).limit
    	assert_response 201, "Didn't create the card successfully."
    	assert_not_nil Card.last.user_wallet_id, "Didn't set the wallet properly."
      assert initial_limit < final_limit, "Wallet Limit didn't update correctly."
    else
    	assert_not_nil nil, "Didn't receive login token"
    end
  end

	test "should not authorize" do
		card = cards(:real)
		post card_create_url params: {card: { number: card.number,
    											 cvv: card.cvv, 
    											 expiration_year: '2020', 
    											 expiration_month: '08', 
    											 limit: card.limit, 
    											 name: card.name, 
    											 name_written: card.name_written}}
    assert_response 401, "Authorized action when it shouldn't."																				 
	end
end
