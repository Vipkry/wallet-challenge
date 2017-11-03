class UserWalletController < ApplicationController
	before_action :authenticate
	
	# POST /user_wallet/show
	def show
		#TODO: return credit_available
		wallet = UserWallet.find_by(:user_id => params[:user_id])
		# credit_available = Cards.where('user_wallet_id = ?', wallet.id).sum(:credit)
		if wallet
			render json: {custom_limit: wallet.custom_limit, limit: wallet.limit}, status: 200
		else
			render json: nil, status: 404
		end
	end


	private

	def authenticate
		user = User.find_by(id: params[:user_id])
		if !user || !user.check_token(params[:token])
			render json: nil, status: 401
		end
	end

end
