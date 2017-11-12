require 'test_helper'

class CardTest < ActiveSupport::TestCase
	setup do
		card = cards(:real)
    @card = Card.new(number: card.number,
                 cvv: card.cvv, 
                 expiration_year: '2020', 
                 expiration_month: '08', 
                 due_day: '20',
                 limit: card.limit,
                 name: card.name,
                 name_written: card.name_written,
                 user_wallet_id: users(:wallet_user).user_wallet.id)
	end

  test "should be a valid card" do
  	assert @card.valid?
  end

  test "should have multiple invalid cards" do
  	@card.save!
    card = Card.new(number: @card.number + "1",
                 cvv: @card.cvv, 
                 expiration_year: '2020', 
                 expiration_month: '08', 
                 due_day: '20',
                 limit: @card.limit,
                 name: @card.name,
                 name_written: @card.name_written,
                 user_wallet_id: users(:wallet_user).user_wallet.id)
    assert card.valid?
    
  	# test name length
  	card.name = "THIS NAME SHOULD BE TOO BIG TO BE VALIDATED LOREM IPSUM DOLOR SIT AMET"
  	assert_not card.valid?
  	card.name = Card.last.name

  	# test name_written length and presence
  	card.name_written = "MyNameIsReallyBig"
  	10.times do
  		card.name_written = card.name_written + card.name_written
  	end
  	assert_not card.valid?
  	card.name_written = "bad"
  	assert_not card.valid?
  	card.name_written = nil
  	assert_not card.valid?
  	card.name_written = "" #empty
  	assert_not card.valid?
  	card.name_written = Card.last.name_written


  	# test number length, presence and numericality
  	card.number = "123123123123"
  	10.times do
  		card.number = card.number + card.number # too big
  	end
  	assert_not card.valid?
  	card.number = "123" #too few
  	assert_not card.valid?
  	card.number = "123JonSnowKnowsNothing" # numericality integer only
  	assert_not card.valid?
  	card.number = nil
  	assert_not card.valid?
  	card.number = "" #empty
  	assert_not card.valid?
  	card.number = Card.last.number

  	# test expiration_month presence and numericality
  	card.expiration_month = "13" # greater than 12
  	assert_not card.valid?
  	card.expiration_month = "-1" # less than 0
  	assert_not card.valid?
  	card.expiration_month = "10JonSnowKnowsNothing1" # numericality integer only
  	assert_not card.valid?
  	card.expiration_month = nil
  	assert_not card.valid?
  	card.expiration_month = "" #empty
  	assert_not card.valid?
  	card.expiration_month = Card.last.expiration_date.month

  	# test expiration_year presence and numericality
  	card.expiration_year = "2015" # less than 2016
  	assert_not card.valid?
  	card.expiration_year = "-1" # greater than 0
  	assert_not card.valid?
  	card.expiration_year = "10JonSnowKnowsNothing1" # numericality integer only
  	assert_not card.valid?
  	card.expiration_year = nil
  	assert_not card.valid?
  	card.expiration_year = "" #empty
  	assert_not card.valid?
  	card.expiration_year = Card.last.expiration_date.year

  	# test due_day presence and numericality
  	card.due_day = "32" # greater than 31
  	assert_not card.valid?
  	card.due_day = "-1" # less than 0
  	assert_not card.valid?
  	card.due_day = "10JonSnowKnowsNothing1" # numericality integer only
  	assert_not card.valid?
  	card.due_day = nil
  	assert_not card.valid?
  	card.due_day = "" #empty
  	assert_not card.valid?
  	card.due_day = Card.last.due_day

  	# test cvv presence and numericality
  	card.cvv = "-1" # less than 0
  	assert_not card.valid?
  	card.cvv = "10JonSnowKnowsNothing1" # numericality integer only
  	assert_not card.valid?
  	card.cvv = nil
  	assert_not card.valid?
  	card.cvv = "" #empty
  	assert_not card.valid?
  	card.cvv = Card.last.cvv
  	
  	# test limit presence and numericality
  	card.limit = "-1" # less than 0
  	assert_not card.valid?
  	card.limit = "10JonSnowKnowsNothing1" # numericality numbers only
  	assert_not card.valid?
  	card.limit = nil
  	assert_not card.valid?
  	card.limit = "" #empty
  	assert_not card.valid?
  	card.limit = Card.last.limit
  end

  test "should set default name value as 'Card'" do
  	@card.name = ""
  	@card.save!
  	assert_equal @card.name, "Card"
  end

  test "should set expiration_date value as Date" do
  	exp_month = @card.expiration_month
  	exp_year = @card.expiration_year
  	assert @card.expiration_date.nil?
  	@card.save!
  	assert_equal @card.expiration_date, Date.new(exp_year.to_i, exp_month.to_i, -1),
  							 "Expected to process expiration_date infos to Date format."
  end

  test "should not let spent be greater than limit" do
    @card.spent = @card.limit + 0.0001
    assert_not @card.valid?
  end
end

