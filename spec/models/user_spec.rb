require 'spec_helper'

describe User do
	before :each do
		@user = User.new
		@attrs = { :email => 'push@broom.com', :token => 'token', :secret => 'secret' }
	end

  it 'should not be valid when missing all attributes' do
  	@user.should_not be_valid, 'User was valid missing all attributes'
  end

  it 'should not be valid with only email' do
  	@user.email = 'push@broom.com'
  	@user.should_not be_valid, 'User was valid with nothing more than an email'
  end

  it 'should not be valid with only a token' do
  	@user.token = 'token'
  	@user.should_not be_valid, 'User was valid with nothing more than a token'
  end

  it 'should not be valid with only a secret' do
  	@user.secret = 'secret'
  	@user.should_not be_valid, 'User was valid with nothing more than a secret'
  end

  it 'should not be valid when missing an email' do
  	@user.attributes = @attrs
  	@user.email = nil
  	@user.should_not be_valid, 'User was valid without an email'
  end

  it 'should not be valid when token is missing' do
  	@user.attributes = @attrs
  	@user.token = nil
  	@user.should_not be_valid, 'User was valid without a token'
  end

  it 'should not be valid when secret is missing' do
  	@user.attributes
  	@user.secret = nil
  	@user.should_not be_valid, 'User was valid without a secret'
  end

  it 'should be valid when no attributes are missing' do
  	User.new(@attrs).should be_valid
  end

  it 'should have many brooms' do
  	@user.should respond_to(:brooms)
  end
end
