require 'test_helper'

class UserWalletTest < ActiveSupport::TestCase
  test "valid UserWallet" do
  	wallet = UserWallet.new(:user_id => User.last.id)

  	assert wallet.valid?
  end

  test "should have user" do
  	wallet = UserWallet.new()
	
	assert_not wallet.valid?
  end

  test "should have limits 0 on creation" do
  	wallet = UserWallet.new(:user_id => User.last.id)
  	wallet.save
  	wallet = UserWallet.last

  	assert_equal wallet.limit, 0.0
  	assert_equal wallet.custom_limit, 0.0
  end
end
