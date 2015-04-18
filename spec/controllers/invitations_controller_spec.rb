require 'spec_helper'

describe InvitationsController do

  describe "GET #new" do
    it_behaves_like "redirect_to_sign_in" do
      let(:action) { get :new }
    end

    it "sets user_id equal to the current user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      get :new
      expect(assigns(:user_id)).to eq(alice.id)
    end
  end

  describe "POST #create" do
    context "a successful invitation" do
      let(:alice) { Fabricate(:user) }

      before do
        set_current_user(alice)
      end

      it "redirects to the users home on success" do
        post :create, invitation: Fabricate.attributes_for(:invitation, user_id: alice.id)
        expect(response).to redirect_to(home_path)
      end

      it "saves the invitation" do
        post :create, invitation: Fabricate.attributes_for(:invitation, user_id: alice.id)
        expect(Invitation.all.count).to eq(1)
      end

      it "saves a token for the invitation" do
        post :create, invitation: Fabricate.attributes_for(:invitation, user_id: alice.id)
        expect(Invitation.first.token).to_not be_nil
      end

      it "sets the success message" do
        post :create, invitation: Fabricate.attributes_for(:invitation, user_id: alice.id)
        expect(flash[:success]).to_not be_nil
      end

      it "sends the invitation email" do
        post :create, invitation: Fabricate.attributes_for(:invitation, user_id: alice.id)
        email = ActionMailer::Base.deliveries.last
        expect(email.body).to include(alice.token)
        ActionMailer::Base.deliveries.clear
      end
    end

    context "if the user_id is not the current user" do
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }

      before do
        set_current_user(alice)
      end

      it "sets renders the new template" do
        post :create, invitation: Fabricate.attributes_for(:invitation, user_id: bob.id)
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        post :create, invitation: Fabricate.attributes_for(:invitation, user_id: bob.id)
        expect(Invitation.all.count).to eq(0)
      end

      it "does not create the invitation with an invalid email address" do
        post :create, invitation: { friend_name: bob.name, friend_email: "bob2example.com", message: Faker::Lorem.sentence, user_id: alice.id }
        expect(Invitation.all.count).to eq(0)
      end

      it "sets the danger message" do
        post :create, invitation: Fabricate.attributes_for(:invitation, user_id: bob.id)
        expect(flash[:danger]).not_to be_nil
      end
    end
  end
end
