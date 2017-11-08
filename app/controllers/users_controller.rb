class UsersController < ApplicationController

  skip_before_action :authenticate, only: [:create, :login]

  # POST /users/login
  def login
    command = AuthenticateUser.call(params[:id_nat], params[:password])

    if command.success?
      render json: { auth_token: command.result }, status: 200
    else 
      render json: { error: command.errors }, status: 401 
    end
  end

  # POST /users/create
  def create
  	@user = User.new(user_params)
  	if @user.save
  	  @user.password_digest = "not-shown"
      wallet = UserWallet.new(:user_id => @user.id)
      wallet.save
      render json: @user, status: 201
    else
      render json: @user.errors, status: 422
    end
  end

  private
  	# don't trust the scary internet
  	def user_params
  	  params.require(:user).permit(:name, :password, :password_confirmation, :id_nat)
  	end
end
