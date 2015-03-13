require 'spec_helper'

describe SessionsController do

  describe "GET #new" do
    it "redirects to home_path if user is logged in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST #create" do
    context "if user is found and authenticated" do
      before do
        @alice = Fabricate(:user)
        post :create, email: @alice.email, password: @alice.password
      end

      it "puts the signed in user in the session" do
        expect(session[:user_id]).to eq(@alice.id)
      end

      it "redirects to the home_path" do
        expect(response).to redirect_to home_path
      end

      it "sets the success notice" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "if user is either not found or not authenticated" do
      before do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'adfad'
      end

      it "does not set the session for an invalid user" do
        expect(session[:user_id]).to eq(nil)
      end

      it "renders the new template" do
        expect(response).to redirect_to sign_in_path
      end

      it "sets the danger notice" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET #destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "sets the session to nil" do
      expect(session[:user_id]).to eq(nil)
    end

    it "sets the success message" do
      expect(flash[:success]).not_to be_blank
    end

    it "redirects to the root path" do
      expect(response).to redirect_to root_path
    end
  end

end
