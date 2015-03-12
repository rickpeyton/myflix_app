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
      it "puts the signed in user in the session" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password
        expect(session[:user_id]).to eq(alice.id)
      end

      it "redirects to the home_path" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password
        expect(response).to redirect_to home_path
      end
    end

    context "if user is either not found or not authenticated"
  end

end
