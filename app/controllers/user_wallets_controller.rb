class UserWalletsController < ApplicationController
	
	# GET /user_wallets/show
	def show
		#TODO: return credit_available
		user = @current_user
		
		wallet = nil
		wallet = UserWallet.find_by(:user_id => user.id) if user

		# credit_available = Cards.where('user_wallet_id = ?', wallet.id).sum(:credit)
		if wallet
			render json: {custom_limit: wallet.custom_limit, limit: wallet.limit}, status: 200
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

end
