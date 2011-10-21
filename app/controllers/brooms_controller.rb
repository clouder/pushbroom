class BroomsController < ApplicationController
	before_filter :check_for_user

	def index
		@brooms = @user.brooms
	end

	def edit
		@broom = @user.brooms.find(params[:id])
	end

	def create
		broom = @user.brooms.build(params[:broom])
		
		if broom.save
			flash[:notice] = 'Your Broom was saved and is ready to sweep!'
			redirect_to brooms_url
		else
			render :new
		end
	end

	def update
		@broom = @user.brooms.find(params[:id])
		if @broom.update_attributes(params[:broom])
			flash[:notice] = 'Your Broom was updated successfully'
			redirect_to brooms_url
		else
			render :edit
		end
	end

	def destroy
		@user.brooms.find(params[:id]).destroy
		flash[:notice] = 'The now useless broom was placed in the bin'
		redirect_to brooms_url
	end

	private

	def check_for_user
		redirect_to root_url unless authorized?
	end

	def authorized?
		@user = User.find(session[:user_id]) if session[:user_id]
	end
end
