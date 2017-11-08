class CardsController < ApplicationController

	# POST /card/create
	def create
		@card = Card.new(card_params)
		@card.user_wallet_id = @current_user.user_wallet.id

		if @card.save
			# only show the last 4 digits of the card
			number = @card.number
			number.reverse!
			number = number.slice(0..3)
			number.reverse!
			@card.number = "**********" +  number

			# don't show the cvv
			@card.cvv = 0
			
			# adjust wallet limit
			@card.user_wallet.update(:limit => @card.user_wallet.limit + @card.limit)

			render json: @card, status: 201
		else
			render json: nil, status: 422
		end
	end

	# GET /card/destroy
	def destroy
		@card = Card.find(params[:id]) if params[:id]
		if @card
			@card.delete

			render json: nil, status: 204
		else
			render json: nil, status: 404
		end
	end


	private
  	# don't trust the scary internet
  	def card_params
  	  params.require(:card).permit(:name, :name_written, :limit, :number, :expiration_month, :expiration_year, :cvv)
  	end
end
