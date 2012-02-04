class BroomsController < ApplicationController
  before_filter :check_for_user, :connect_gmail
  after_filter :disconnect_gmail

  def index
    @brooms = @user.brooms
    @broom = Broom.new
  end

  def show
    redirect_to edit_broom_url(params[:id])
  end

  def edit
    @brooms = @user.brooms
    @broom = @user.brooms.find(params[:id])
  end

  def create
    @broom = @user.brooms.build(params[:broom])

    if @broom.save
      flash[:notice] = 'Your Broom was saved and is ready to sweep!'
      redirect_to brooms_url
    else
      @brooms = @user.brooms - [@broom]
      render :index
    end
  end

  def update
    @broom = @user.brooms.find(params[:id])
    if @broom.update_attributes(params[:broom])
      flash[:notice] = 'Your Broom was updated successfully'
      redirect_to brooms_url
    else
      @brooms = @user.brooms
      render :edit
    end
  end

  def destroy
    @user.brooms.find(params[:id]).destroy
    flash[:notice] = 'The now useless broom was placed in the bin'
    redirect_to brooms_url
  end

  def sweep
    ::PushbroomSweepers.manual_sweep(params[:id])
    redirect_to brooms_url
  end

  private

  def check_for_user
    redirect_to root_url unless authorized?
  end

  def connect_gmail
    @gmail = Gmail.connect(
      :xoauth, @user.email,
      :token => @user.token, :secret => @user.secret,
      :consumer_key => Pushbroom::Application.config.consumer_key,
      :consumer_secret => Pushbroom::Application.config.consumer_secret
    )
  end

  def disconnect_gmail
    @gmail.logout
  end
end
