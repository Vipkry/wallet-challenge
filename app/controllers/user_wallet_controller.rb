class UserWalletController < ApplicationController
	
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

end
