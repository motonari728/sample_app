class MicropostsController < ApplicationController
	before_action :signed_in_user
	before_action :correct_user, only: :destroy

	def create
		@micropost = current_user.microposts.build(micropost_params) # Strong Parameters
		if @micropost.save
			flash[:succeess] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = [] 
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content)
		end

		def correct_user
			@micropost = current_user.microposts.find_by(id: params[:id]) #findだと例外が発生してしまう
			redirect_to rooturl if @micropost.nil? #自分のポストがなければnilになる
		end
end