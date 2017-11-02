require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest

  test "should create user" do
    assert_difference('User.count') do
    	post user_create_url, params: {user: { name: 'Kerrigan', password: '1234567890', id_nat: '17915160419' }}
    end

    assert_response 201
  end

  test "return unprocessable entity upon error" do
    # password souln't be blank
  	post user_create_url, params: {user: { name: 'Kerrigan', password: '', id_nat: '17915160419' }}
    assert_response 422, "Didn't receive error header on invalid user request (no password)"
    
    # name shouldn't be blank?
    post user_create_url, params: {user: { name: '', password: '123123123', id_nat: '17915160419' }}
    assert_response 422, "Didn't receive error header on invalid user request (no name)"
    
    # id_nat shouldn't be blank?
    post user_create_url, params: {user: { name: 'Kerrigan', password: '123123123', id_nat: '' }}
    assert_response 422, "Didn't receive error header on invalid user request (no id_nat)"
  end

  test "should return login token" do
    user = users(:one)
    post user_login_url, params: {id_nat: user.id_nat, password: 'foobar'}
    
    assert_response 200, "Login wasn't successful or it didn't return the correct response"
    assert_not_empty @response.body, "No token received upon login"
  end

  test "should log in" do
    user = users(:one)
    post user_login_url, params: {id_nat: user.id_nat, password: 'foobar'}
    
    # call the user again so it brings from the database and not from the fixture
    user_aux = User.find_by(:id_nat => user.id_nat)
    if user_aux
      assert_equal user_aux.login_token, @response.body, "Login token wasn't saved on the correct user"
    else 
      flunk "User wasn't found."
    end
  end

  test "should not return login token" do
    post user_login_url, params: {id_nat: users(:one).id_nat, password: 'not_foobar'}

    assert_response 401, "Login was successful when it shouldn't be or it didn't return the correct response"
    assert_equal @response.body, 'null', "Token received upon incorrect login"
  end

end
