class UserController < ApplicationController
  
  # GET /user/index
  def index
  	@users = User.all
  	render json: @users, status: 200
  end

  # POST /user/create
  def create
  	@user = User.new(user_params)
  	if @user.save
  	  @user.password_digest = "not-shown"
      render json: @user, status: 201
    else
      render json: @user.errors, status: 422
    end
  end

  # GET /user/login
  def login
  	#TODO -> implement token based login
  	@token = User.new_token
  	render json: @token
  end

  private
	# don't trust the scary internet
	def user_params
	  params.require(:user).permit(:name, :password, :password_confirmation, :id_nat)
	end
end
