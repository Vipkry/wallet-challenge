class CardController < ApplicationController

	# POST /card/create
	def create
		@card = Card.new(card_params)
		@card.user_wallet_id = @current_user.user_wallet.id

		if @card.save

			@card.cvv = "not-shown"

			render json: @card, status: 201
		else
			render json: nil, status: 422
		end
	end


	private
  	# don't trust the scary internet
  	def card_params
  	  params.require(:card).permit(:name, :name_written, :limit, :number, :expiration_month, :expiration_year, :cvv)
  	end
end
