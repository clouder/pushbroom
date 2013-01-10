require 'spec_helper'

def prepare_auth
  session[:user_id] = 1
  User.stub(:find).with(1).and_return(stub_model(User))
  controller.stub(:connect_gmail)
  controller.stub(:disconnect_gmail)
end

describe BroomsController do
  describe '#index' do
    context 'when unauthorized' do
      it 'redirects to root_url' do
        get :index
        response.should redirect_to root_url
      end
    end

    context 'when authorized' do
      before :each do
        prepare_auth
      end

      it 'responds with success' do
        get :index
        response.should be_success
      end

      it 'assigns @brooms' do
        get :index
        assigns(:brooms).should be
      end
    end
  end

  describe '#edit' do
    context 'when unauthorized' do
      it 'redirects to root_url' do
        get :edit, id: 1
        response.should redirect_to root_url
      end
    end

    context 'when authorized' do
      before :each do
        prepare_auth
        User.any_instance.stub_chain(:brooms, :find).and_return Broom.new
      end

      it 'responds with success' do
        get :edit, id: 1
        response.should be_success
      end

      it 'assigns @broom' do
        get :edit, id: 1
        response.should be_success
      end
    end
  end

  describe '#create' do
    context 'when unauthorized' do
      it 'redirects to root_url' do
        post :create
        response.should redirect_to root_url
      end
    end

    context 'when authorized' do
      before :each do
        prepare_auth
      end

      context 'when @broom is not saved' do
        it 'responds with success' do
          post :create
          response.should be_success
        end

        it 'renders #index' do
          post :create
          response.should render_template :index
        end
      end

      context 'when @broom is saved' do
        before :each do
          broom = stub_model Broom, :save => true
          User.any_instance.stub_chain(:brooms, :build).and_return(broom)
        end

        it 'redirects to brooms_url' do
          post :create
          response.should redirect_to brooms_url
        end

        it 'sets a flash notice to something pleasant' do
          post :create
          flash[:notice].should eq 'Your Broom was saved and is ready to sweep!'
        end
      end
    end
  end

  describe '#update' do
    context 'when unauthorized' do
      it 'redirects to root_url' do
        put :update, id: 1
        response.should redirect_to root_url
      end
    end

    context 'when authorized' do
      before :each do
        prepare_auth
        broom = stub_model Broom
        User.any_instance.stub_chain(:brooms, :find).and_return broom
      end

      context 'when @broom is not successfully updated' do
        before :each do
          Broom.any_instance.stub(:update_attributes).and_return false
        end

        it 'responds with success' do
          put :update, id: 1
          response.should be_success
        end

        it 'renders #edit' do
          put :update, id: 1
          response.should render_template :edit
        end
      end

      context 'when @broom is successfully updated' do
        before :each do
          Broom.any_instance.stub(:update_attributes).and_return true
        end

        it 'responds with redirect' do
          put :update, id: 1
          response.should be_redirect
        end

        it 'sets a flash notice to something pleasant' do
          put :update, id: 1
          flash[:notice].should eq 'Your Broom was updated successfully'
        end
      end
    end
  end

  describe '#destroy' do
    context 'when unauthorized' do
      it 'redirects to root_url' do
        delete :destroy, id: 1
        response.should redirect_to root_url
      end
    end

    context 'when authorized' do
      before :each do
        prepare_auth
        User.any_instance.stub_chain(:brooms, :find).and_return Broom.new
      end

      it 'redirects to brooms_url' do
        delete :destroy, id: 1
        response.should redirect_to brooms_url
      end

      it 'sets a flash notice informing of broom deletion' do
        delete :destroy, id: 1
        flash[:notice].should eq 'The now useless broom was placed in the bin'
      end
    end
  end
end
