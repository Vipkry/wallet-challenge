class CardsController < ApplicationController

	# POST /cards/create
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
			render json: @card.errors, status: 422
		end
	end

	# DELETE /cards/
	def destroy
		@card = Card.find(params[:id]) if params[:id]
		if @card
			if @card.user_wallet_id == @current_user.user_wallet.id
				user_wallet = @card.user_wallet
				user_wallet.update(:limit => user_wallet.limit - @card.limit) #update wallet limit to adjust the card removal
				@card.delete
				render status: 204
			else
				render json: {error: "Not Authorized"}, status: 401 # tried to delete a card of someone else
			end
		else
			render status: 404 # card not found
		end
	end


	private
  	# don't trust the scary internet
  	def card_params
  	  params.require(:card).permit(:name, :name_written, :limit, :number, :expiration_month, :expiration_year, :cvv, :due_date_day)
  	end
end
