require 'spec_helper'

describe UsersController do

  describe "GET #new" do
    it "redirects to home_path if user is already logged in" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets @user if user is not logged in" do
      get :new
      expect(assigns(:user)).to be_an_instance_of(User)
    end
  end

  describe "POST #create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the home_path" do
        expect(response).to redirect_to home_path
      end

      it "sets the user into the session" do
        expect(session[:user_id]).to eq(User.first.id)
      end
    end

    context "with invalid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user,
                                                     password: nil)
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets the user variable" do
        expect(assigns(:user)).to be_an_instance_of(User)
      end
    end
  end

end
