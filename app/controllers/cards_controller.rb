class CardsController < ApplicationController
	require 'bigdecimal'
	# POST /cards/create
	def create
		@card = Card.new(card_params)
		@card.user_wallet_id = @current_user.user_wallet.id

		if @card.save
			# adjust wallet limit
			@card.user_wallet.update(:limit => @card.user_wallet.limit + @card.limit)

			@card.hide_confidencial_info
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

	# GET /cards/pay
	def pay
		unless params[:ammount].nil? || params[:ammount].empty?
			ammount = BigDecimal.new(params[:ammount]) #check
			ammount = ammount * - 1 if ammount < 0 #don't let negative values pass through
			@card = Card.find(params[:id]) if params[:id]
			if @card
				if @card.user_wallet_id == @current_user.user_wallet.id
					if @card.spent < ammount
						@card.update(:spent => 0)
					else
						@card.update(:spent => @card.spent - ammount)
					end
					@card.hide_confidencial_info
					render json: @card, status: 200
				else
					render json: {error: "Not Authorized."}, status: 401 # tried to pay a card of someone else
				end
			else
				render json: {error: "Should have a valid card id."}, status: 404
			end
		else
			render json: {error: "Should have an ammount."}, status: 400
		end
	end		


	private
  	# don't trust the scary internet
  	def card_params
  	  params.require(:card).permit(:name, :name_written, :limit, :number, :expiration_month, :expiration_year, :cvv, :due_date_day)
  	end
end
