require 'spec_helper'

describe PasswordsController do
  describe "GET show" do
    context "with valid token" do
      it "renders the show template" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, SecureRandom.urlsafe_base64)
        get :show, id: alice.token
        expect(response).to render_template(:show)
      end
    end

    context "with invalid token" do
      it "redirects to the invalid token page" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, "abc")
        get :show, id: "123"
        expect(response).to redirect_to invalid_token_path
      end
    end
  end

  describe "POST create" do
    it "redirects to welcome page" do
      alice = Fabricate(:user)
      post :create, email: alice.email
      expect(response).to redirect_to root_path
    end

    it "sets the success message" do
      alice = Fabricate(:user)
      post :create, email: alice.email
      expect(flash[:success]).to_not be_empty
    end

    it "generates a user password reset token if the email address is valid" do
      alice = Fabricate(:user)
      post :create, email: alice.email
      expect(User.first.token).to_not be_empty
    end

    it "it sends an email to the user that contains the tokenized link" do
      alice = Fabricate(:user)
      post :create, email: alice.email
      email = ActionMailer::Base.deliveries.last
      expect(email.body).to include(alice.token)
      ActionMailer::Base.deliveries.clear
    end
  end

  describe "PATCH #update" do
    context "with a valid new password and token" do
      it "updates the user password" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, SecureRandom.urlsafe_base64)
        patch :update, id: alice.token, password: "password2"
        expect(User.first.authenticate("password2")).to be_truthy
      end

      it "redirects to the sign-in page" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, SecureRandom.urlsafe_base64)
        patch :update, id: alice.token, password: "password2"
        expect(response).to redirect_to sign_in_path
      end

      it "clears the token" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, SecureRandom.urlsafe_base64)
        patch :update, id: alice.token, password: "password2"
        expect(User.first.token).to be_nil
      end

      it "sets the success message" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, SecureRandom.urlsafe_base64)
        patch :update, id: alice.token, password: "password2"
        expect(flash[:success]).to_not be_nil
      end
    end

    context "with a valid token but invalid password" do
      it "renders the new tempate" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, SecureRandom.urlsafe_base64)
        patch :update, id: alice.token, password: "pass"
        expect(response).to render_template :show
      end

      it "sets the danger message" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, SecureRandom.urlsafe_base64)
        patch :update, id: alice.token, password: "pass"
        expect(flash[:danger]).not_to be_nil
      end

      it "does not delete the token" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, SecureRandom.urlsafe_base64)
        patch :update, id: alice.token, password: "pass"
        expect(User.first.token).to eq(alice.token)
      end
    end

    context "with a valid password but invalid token" do
      it "redirects to the invalid token path" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, SecureRandom.urlsafe_base64)
        patch :update, id: "abc123", password: "password2"
        expect(response).to redirect_to invalid_token_path
      end

      it "does not change the password" do
        alice = Fabricate(:user)
        alice.update_attribute(:token, SecureRandom.urlsafe_base64)
        patch :update, id: "abc123", password: "password2"
        expect(User.first.authenticate("password2")).to be_falsey
      end
    end
  end
end
