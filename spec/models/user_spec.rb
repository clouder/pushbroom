require 'spec_helper'

describe User do
  context 'with missing email, token, or secret' do
    before :each do
      @user = User.new
      @user.valid?
    end

    it 'is invalid' do
      @user.should_not be_valid
    end

    it 'has an error on email' do
      @user.errors.get(:email).should be
    end

    it 'has an error on token' do
      @user.errors.get(:token).should be
    end

    it 'has an error on secret' do
      @user.errors.get(:secret).should be
    end
  end

  context 'with email, token, and secret' do
    before :each do
      @user = User.new :email => 'push@broom.com', :token => 'token', :secret => 'secret'
    end
    it 'is valid' do
      @user.should be_valid
    end
  end

  it 'has many brooms' do
    User.new.should respond_to :brooms
  end
end
