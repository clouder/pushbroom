require 'spec_helper'

describe SessionsController do
  describe '#index' do
    context 'when authorized' do
      it 'redirects to brooms_url' do
        controller.stub(:authorized?).and_return true
        get :index
        response.should redirect_to brooms_url
      end
    end

    context 'when unauthorized' do
      it 'responds with success' do
        get :index
        response.should be_success
      end
    end
  end

  describe '#new' do
    context 'when authorized' do
      it 'redirects to brooms_url' do
        controller.stub(:authorized?).and_return true
        get :new
        response.should redirect_to brooms_url
      end
    end

    context 'when unauthorized' do
      context 'with an empty session' do
        before :each do
          request_token = mock OAuth::RequestToken, :token => 'token', :secret => 'secret', :authorize_url => '/accounts/OAuthAuthorizeToken'
          OAuth::Consumer.any_instance.stub(:get_request_token).and_return request_token
          get :new
        end

        it 'redirects to /accounts/OAuthAuthorizeToken' do
          response.should redirect_to '/accounts/OAuthAuthorizeToken'
        end

        it 'sets session[:oauth][:request_token]' do
          session[:oauth][:request_token].should eq 'token'
        end

        it 'sets session[:oauth][:request_secret]' do
          session[:oauth][:request_secret].should eq 'secret'
        end
      end

      context 'with session[:oauth]' do
        before :each do
          session[:oauth] = { :request_token => 'token', :request_secret => 'secret' }
        end

        context 'having authorized tokens' do
          before :each do
          	response = mock(Net::HTTPSuccess, :body => '{"data":{"email": "push@broom.com"}}')
            access_token = mock(OAuth::AccessToken, :get => response, :token => 'token', :secret => 'secret')
            OAuth::RequestToken.any_instance.stub(:get_access_token).and_return access_token
            User.stub(:find_or_initialize_by_email).and_return(stub_model(User))
          end

          it 'redirects to brooms_url' do
            get :new
            response.should redirect_to brooms_url
          end

          it 'sets session[:user_id]' do
            get :new
            session[:user_id].should be
          end

          it 'clears session[:oauth]' do
            get :new
            session[:oauth].should_not be
          end
        end

        context 'having unauthorized tokens' do
          it 'redirects to root_url' do
            get :new
            response.should redirect_to root_url
          end

          it 'sets flash error' do
            get :new
            flash[:error].should match /not granted permission/
          end

          it 'resets the session' do
            get :new
            session.should be_blank
          end
        end
      end
    end
  end

  describe 'GET #destroy' do
    it 'redirects to root_url' do
      get :destroy
      response.should redirect_to root_url
    end

    it 'clears user session' do
      session[:user_id] = 1
      get :destroy
      session.should be_blank
    end
  end
end
