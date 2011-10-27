require 'spec_helper'

describe SessionsController, 'when authorized' do
	before :each do
		controller.stub(:authorized?).and_return(true)
	end

	it 'should redirect to brooms_url' do
		get :index
		response.should redirect_to(brooms_url)
		get :new
		response.should redirect_to(brooms_url)
	end

	describe 'on get :destroy' do
		before :each do
			session[:user_id] = 1
			get :destroy
		end

		it 'should clear the user session' do
			session.should be_blank
		end

		it 'should redirect to root_url' do
			response.should redirect_to(root_url)
		end
	end
end

describe SessionsController, 'when unauthorized' do
	it 'should respond with success on GET :index' do
		get :index
		response.should be_success
	end

	describe 'on GET :new with empty session' do
		before :each do
			request_token = mock(OAuth::RequestToken, :token => 'token', :secret => 'secret')
			request_token.stub(:authorize_url).and_return('/accounts/OAuthAuthorizeToken')
			OAuth::Consumer.any_instance.stub(:get_request_token).and_return(request_token)
			get :new
		end

		it 'should redirect to /accounts/OAuthAuthorizeToken' do
		  response.should redirect_to('/accounts/OAuthAuthorizeToken')
		end

		it 'should set session[:oauth][:request_token]' do
			session[:oauth][:request_token].should eq('token')
		end

		it 'should set session[:oauth][:request_secret]' do
			session[:oauth][:request_secret].should eq('secret')
		end
	end

	describe 'on GET :new with session[:oauth][:request_token]' do
		before :each do
			session[:oauth] = {}
			session[:oauth][:request_token] = 'token'
			session[:oauth][:request_secret] = 'secret'
			response = mock(Net::HTTPSuccess, :body => '{"data":{"email": "push@broom.com"}}')
			access_token = mock(OAuth::AccessToken, :get => response, :token => 'token', :secret => 'secret')
			OAuth::RequestToken.any_instance.stub(:get_access_token).and_return(access_token)
			User.stub(:find_or_initialize_by_email).and_return(stub_model(User))
		end

		it 'should redirect to brooms_url' do
			get :new
			response.should redirect_to(brooms_url)
		end

		it 'should find or setup and save a user' do
			User.should_receive(:find_or_initialize_by_email).with('push@broom.com')
			User.any_instance.should_receive(:attributes=).with({ :token => 'token', :secret => 'secret' })
			get :new
		end

		it 'should set session[:user_id]' do
			get :new
		  session[:user_id].should_not be_blank
		end

		it 'should blank session[:oauth]' do
			get :new
			session[:oauth].should be_blank
		end

		describe 'but the user denies access on Google page' do
			before :each do
				OAuth::RequestToken.any_instance.stub(:get_access_token).and_raise(OAuth::Unauthorized)
			end
			
			it 'should redirect to root_url' do
				get :new
				response.should redirect_to(root_url)
			end

			it 'should set flash[:error] with info of the mishap' do
				get :new
				flash[:error].should eq("Oops, we were not granted permission. You may try again if you like.")
			end

			it 'should reset the session' do
			  get :new
			  session.should be_blank
			end
		end
	end
end