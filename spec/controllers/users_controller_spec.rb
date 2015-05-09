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
    context "with valid personal info and valid card" do
      let(:charge) { double(successful?: true) }

      before do
        expect(StripeWrapper::Charge).to receive(:create) { charge }
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

    context "with valid personal info and a valid token" do
      let(:charge) { double(successful?: true) }

      before do
        expect(StripeWrapper::Charge).to receive(:create) { charge }
      end

      it "creates a relationship between invitee and invitor" do
        alice = Fabricate(:user)
        invite = Fabricate(:invitation, user_id: alice.id)
        post :create,
          user: Fabricate.attributes_for(:user,friend_token: invite.token)
        expect(Relationship.where(["leader_id = ? and follower_id = ?",
                                   alice.id, User.last.id]).count).to eq(1)
      end

      it "creates a relationship between invitor and invitee" do
        alice = Fabricate(:user)
        invite = Fabricate(:invitation, user_id: alice.id)
        post :create,
          user: Fabricate.attributes_for(:user,friend_token: invite.token)
        expect(Relationship.where(["leader_id = ? and follower_id = ?",
                                   User.last.id, alice.id]).count).to eq(1)
      end
    end

    context "email sending with valid personal info" do
      let(:charge) { double(successful?: true) }

      before do
        expect(StripeWrapper::Charge).to receive(:create) { charge }
        post :create, user: Fabricate.attributes_for(:user)
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "sends the email" do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it "sends to the right recipient" do
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq([User.first.email])
      end

      it "contains the correct message" do
        email = ActionMailer::Base.deliveries.last
        expect(email.body).to include("Welcome to MyFlix")
      end

    end

    context "do not send email with invalid inputs" do
      before do
        ActionMailer::Base.deliveries.clear
      end

      it "should not send an email" do
        post :create, user: Fabricate.attributes_for(:user, password: "pass")
        expect(ActionMailer::Base.deliveries).to be_empty
        ActionMailer::Base.deliveries.clear
      end
    end

    context "with invalid personal info" do
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

      it "does not charge the credit card" do
        expect(StripeWrapper::Charge).not_to receive(:create) { charge }
      end
    end

    context "valid personal info and declined card" do

      let(:charge) { double(:charge, successful?: false, error_message: "Your card was declined") }

      it "does not create a new user record" do
        expect(StripeWrapper::Charge).to receive(:create) { charge }
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
        expect(User.count).to eq 0
      end

      it "renders the new template" do
        expect(StripeWrapper::Charge).to receive(:create) { charge }
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        expect(StripeWrapper::Charge).to receive(:create) { charge }
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
        expect(flash[:danger]).to be_present
      end
    end
  end

end
