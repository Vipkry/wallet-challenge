class UserWalletController < ApplicationController
	# TODO before_action authenticate
	
	# POST /user_wallet/show
	def show
		#* O user deve ser capaz de acessar as informações de sua wallet a qualquer momento (limite setado pelo o user, limite máximo e crédito disponível)
		wallet = UserWallet.find_by(:user_id => params[:user_id])
		# credit = Cards.where('user_wallet_id = ?', wallet.id).sum(:credit)
		render json: {custom_limit: wallet.custom_limit, limit: wallet.limit}, status: 200
	end

end
