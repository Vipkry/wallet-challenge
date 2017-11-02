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
end
