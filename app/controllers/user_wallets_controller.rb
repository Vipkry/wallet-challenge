class UserWalletsController < ApplicationController
	require 'bigdecimal'	

	# GET /user_wallets/show
	def show
		user = @current_user
		
		wallet = nil
		wallet = UserWallet.find_by(:user_id => user.id) if user

		total_spent = Card.where('user_wallet_id = ?', wallet.id).sum(:spent)
		credit_available = wallet.custom_limit - total_spent
		credit_available = 0 if credit_available < 0 # no need to show negative values to users
		if wallet
			render json: {custom_limit: wallet.custom_limit, limit: wallet.limit, credit: wallet.custom_limit - total_spent}, status: 200
		else
			render status: 404
		end
	end

	# GET /user_wallets/show_cards
	def show_cards
		user = @current_user

		wallet = nil
		wallet = UserWallet.find_by(:user_id => user.id) if user

		if wallet 
			@cards = wallet.cards

			@cards.each do |card|
				# only show the last 4 digits of the card
				number = card.number
				number.reverse!
				number = number.slice(0..3)
				number.reverse!
				card.number = "**********" +  number

				# don't show the cvv
				card.cvv = 0
			end

			render json: @cards, status: 200
		else
			render status: 404
		end
	end

	# GET /user_wallets/set_custom_limit
	def set_custom_limit
		user = @current_user
		@wallet = nil
		@wallet = UserWallet.find_by(:user_id => user.id) if user
		if @wallet
			unless params[:custom_limit].nil? || params[:custom_limit].empty?
				custom_limit = BigDecimal.new(params[:custom_limit])
				custom_limit = 0 if custom_limit < 0 # dont let the user input negative values
				custom_limit = @wallet.limit if custom_limit > @wallet.limit # nor a value higher than the actual limit
				@wallet.update(:custom_limit => custom_limit)
				render json: @wallet, status: 200
			else
				render status: 400
			end
		else
			render status: 404
		end
	end

end
