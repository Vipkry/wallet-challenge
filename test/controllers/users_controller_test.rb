require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "should create user" do
    assert_difference('User.count') do
    	post users_create_url, params: {user: { name: 'Kerrigan', password: '1234567890', id_nat: '17915160419' }}
    end

    assert_response 201
  end

  test "should have a wallet" do
    post users_create_url, params: {user: { name: 'Kerrigan', password: '1234567890', id_nat: '12345678900' }}
    
    wallet_id = User.last.user_wallet.id

    assert_not_nil wallet_id
  end

  test "return unprocessable entity upon error" do
    # password souln't be blank
  	post users_create_url, params: {user: { name: 'Kerrigan', password: '', id_nat: '17915160419' }}
    assert_response 422, "Didn't receive error header on invalid user request (no password)"
    
    # name shouldn't be blank?
    post users_create_url, params: {user: { name: '', password: '123123123', id_nat: '17915160419' }}
    assert_response 422, "Didn't receive error header on invalid user request (no name)"
    
    # id_nat shouldn't be blank?
    post users_create_url, params: {user: { name: 'Kerrigan', password: '123123123', id_nat: '' }}
    assert_response 422, "Didn't receive error header on invalid user request (no id_nat)"
  end

  test "should return login token" do
    post users_login_url, params: {id_nat: users(:one).id_nat, password: 'foobar'}
    
    assert_response 200, "Login wasn't successful or it didn't return the correct response"
    assert_not_empty JSON.parse(@response.body)['auth_token'], "No token received upon login"
  end

  test "should not return login token" do
    post users_login_url, params: {id_nat: users(:one).id_nat, password: 'not_foobar'}

    assert_response 401, "Login was successful when it shouldn't be or it didn't return the correct response"
  end

end
