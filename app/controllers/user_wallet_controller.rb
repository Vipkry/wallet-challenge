class UserWalletController < ApplicationController
	
	# POST /user_wallet/show
	def show
		#TODO: return credit_available
		user = User.find_by(:id_nat => params[:id_nat])
		
		wallet = nil
		wallet = UserWallet.find_by(:user_id => user.id) if user

		# credit_available = Cards.where('user_wallet_id = ?', wallet.id).sum(:credit)
		if wallet
			render json: {custom_limit: wallet.custom_limit, limit: wallet.limit}, status: 200
		else
			render json: nil, status: 404
		end
	end

end
