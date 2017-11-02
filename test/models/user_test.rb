require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should create valid user" do
  	foo = User.new(:name => "Jon Snow", :password => "I know nothing!", :id_nat => "05767887653")
  	assert foo.valid?
  end

  test "invalid user with no password" do
  	foo = User.new(:name => "Jon Snow", :password => "", :id_nat => "05767887653")
  	assert_not foo.valid?
  end

  test "invalid user with no id_nat" do
  	foo = User.new(:name => "Jon Snow", :password => "I know nothing!", :id_nat => "")
  	assert_not foo.valid?
  end

  test "invalid user with no name" do
	foo = User.new(:name => "", :password => "I know nothing!", :id_nat => "05767887653")
  	assert_not foo.valid?
  end

end
