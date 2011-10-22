require 'spec_helper'

describe BroomsController, 'when unauthorized' do
	it 'should respond with a redirect all the time' do
		get :index
		response.should be_redirect, 'GET index did not respond with redirect'
		get :edit, :id => 1
		response.should be_redirect, 'GET edit did not respond with redirect'
		post :create, :broom => { :number => 5, :unit => 'days', :labels => %w{ work play } }
		response.should be_redirect, 'POST create did not respond with redirect'
		put :update, :id => 1, :broom => { :number => 5 }
		response.should be_redirect, 'PUT update did not respond with redirect'
		delete :destroy, :id => 1
		response.should be_redirect, 'DELETE destroy did not respond with redirect'
	end

	it 'should redirect to root_url all the time' do
		get :index
		response.should redirect_to(root_url), 'GET index did not redirect to root_url'
		get :edit, :id => 1
		response.should redirect_to(root_url), 'GET edit did not redirect to root_url'
		post :create, :broom => { :number => 5, :unit => 'days', :labels => %w{ work play } }
		response.should redirect_to(root_url), 'POST create did not redirect to root_url'
		put :update, :id => 1, :broom => { :number => 5 }
		response.should redirect_to(root_url), 'PUT update did not redirect to root_url'
		delete :destroy, :id => 1
		response.should redirect_to(root_url), 'DELETE destroy did not redirect to root_url'
	end
end

describe BroomsController, 'when authorized' do
	before :each do
		session[:user_id] = 1
		User.stub(:find).with(1).and_return(stub_model(User))
	end

	describe 'on GET index' do
		before :each do
			get :index
		end

		it 'should respond with success' do
			response.should be_success
		end

		it 'should assign @brooms' do
			assigns(:brooms).should_not be_nil, '@brooms was nil'
			assigns(:brooms).should eq([]), '@brooms was not an empty array'
		end
	end

	describe 'on GET edit with valid Broom id' do
		before :each do
			User.any_instance.stub_chain(:brooms, :find).and_return(Broom.new)
			get :edit, :id => 1
		end

		it 'should respond with success' do
			response.should be_success
		end

		it 'should assign @broom' do
			assigns(:broom).should_not be_nil, '@broom was nil'
			assigns(:broom).should be_a(Broom), '@broom was not a Broom'
		end
	end

	describe 'on POST create with valid Broom values' do
		before :each do
			broom = mock_model(Broom, :save => true)
			User.any_instance.stub_chain(:brooms, :build).and_return(broom)
			post :create, :broom => { :number => 5, :unit => 'days', :labels => %w{ work play } }
		end

		it 'should redirect to brooms_url' do
			response.should redirect_to(brooms_url)
		end

		it 'should set flash[:notice] to something happy' do
			flash[:notice].should eq('Your Broom was saved and is ready to sweep!')
		end
	end

	describe 'on POST create with invalid Broom values' do
		before :each do
			post :create, :broom => { :number => 0, :unit => 'eval("`rm -rf")', :labels => %w{ work play } }
		end

		it 'should not redirect' do
			response.should_not be_redirect
		end

		it 'should render the new template' do
			should render_template(:new)
		end
	end

	describe 'on PUT update with valid Broom values' do
		before :each do
			broom = stub_model(Broom, :save => true)
			User.any_instance.stub_chain(:brooms, :find).and_return(broom)
			put :update, :id => 1, :broom => { :number => 5 }
		end
		
		it 'should redirect to brooms_url' do
			response.should redirect_to(brooms_url)
		end

		it 'should set flash[:notice] to something happy' do
			flash[:notice].should eq('Your Broom was updated successfully')
		end
	end

	describe 'on PUT update with invalid Broom values' do
		before :each do
			broom = stub_model(Broom, :save => false)
			User.any_instance.stub_chain(:brooms, :find).and_return(broom)
			put :update, :id => 1, :broom => { :number => 5.5 }
		end

		it 'should not redirect' do
			response.should_not be_redirect
		end

		it 'should render the edit template' do
			should render_template(:edit)
		end
	end

	describe 'on DELETE destroy' do
		before :each do
			User.any_instance.stub_chain(:brooms, :find).and_return(Broom.new)
			delete :destroy, :id => 1
		end

		it 'should redirect to brooms_url' do
			response.should redirect_to(brooms_url)
		end

		it 'should set flash[:notice] to some informative' do
			flash[:notice].should eq('The now useless broom was placed in the bin')
		end
	end
end
