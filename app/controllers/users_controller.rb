class UsersController < ApplicationController

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
             sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end
# params.require(key).permit(filter)
# key
#   Strong Parameters を適用したい params の key を指定する。
# filter
#   Strong Parameters で許可するカラムを指定する。
end
