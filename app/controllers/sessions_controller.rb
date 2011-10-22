class SessionsController < ApplicationController
	before_filter :check_for_user, :except => :destroy

	def index
		
	end

	def new
		session[:oauth] ||= {}
		consumer = OAuth::Consumer.new(
			'anonymous', 'anonymous', :site => 'https://www.google.com',
			:request_token_path => '/accounts/OAuthGetRequestToken?scope=https://mail.google.com/%20https://www.googleapis.com/auth/userinfo%23email',
			:access_token_path => '/accounts/OAuthGetAccessToken',
			:authorize_path => '/account/OAuthAuthorizeToken'
		)

		if session[:oauth][:request_token]
			request_token = OAuth::RequestToken.new(consumer, session[:oauth][:request_token], session[:oauth][:request_secret])
			reset_session

			begin
				access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
			rescue	OAuth::Unauthorized
				flash[:error] = 'Oops, we were not granted permission. You may try again if you like.'
				redirect_to root_url and return
			end

			response = access_token.get('https://www.googleapis.com/userinfo/email?alt=json')
			email = JSON.parse(response.body)['data']['email']
			user = User.find_or_initialize_by_email(email)
			user.attributes = { :token => access_token.token, :secret => access_token.secret }
			user.save
			session[:user_id] = user.id
			redirect_to brooms_url
		else
			request_token = consumer.get_request_token(:oauth_callback => "#{request.scheme}://#{request.host}:#{request.port}/login")
			session[:oauth][:request_token] = request_token.token
			session[:oauth][:request_secret] = request_token.secret
			redirect_to '/accounts/OAuthAuthorizeToken'
		end
	end

	def destroy
		reset_session
		redirect_to root_url
	end

	private

	def check_for_user
		redirect_to brooms_url if authorized?
	end
end
