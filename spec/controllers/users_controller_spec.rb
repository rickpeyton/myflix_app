require 'spec_helper'

describe UsersController do

  describe "GET #show" do
    it_behaves_like "redirect_to_sign_in" do
      let(:action) { get :show, id: 1 }
    end

    it "should set the user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end

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

    it "sets the @token variable if a valid token parameter is present" do
      alice = Fabricate(:user)
      invite = Fabricate(:invitation, user_id: alice.id)
      get :new, token: invite.token
      expect(assigns(:token)).to eq(invite.token)
    end

    it "does not set the @token variable if a valid token is not found" do
      get :new, token: "abc123"
      expect(assigns(:token)).to be_nil
    end
  end

  describe "POST #create" do
    context "successful user signup" do
      before do
        result = double(:sign_up_result, successful?: true)
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "redirects to the home_path" do
        expect(response).to redirect_to home_path
      end

      # it "sets the user into the session" do
      #   expect(session[:user_id]).to eq(User.first.id)
      # end

      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "failed user signup" do
      before do
        result = double(:sign_up_result, successful?: false,
                       error_message: "An error message")
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets the flash danger message" do
        expect(flash[:danger]).to be_present
      end

      it "sets the user variable" do
        expect(assigns(:user)).to be_an_instance_of(User)
      end
    end
  end
end
