require 'spec_helper'

describe RelationshipsController do
  describe "GET #index" do
    it "sets the relationships variable to the current user's following relationships" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "redirect_to_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "POST #create" do
    it_behaves_like "redirect_to_sign_in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "redirects to the people path after adding a new leader for a valid user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader: bob
      expect(response).to redirect_to people_path
    end

    it "creates a new leader follower relationship when the follower is the current user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader: bob
      expect(Relationship.first.follower).to eq(alice)
    end

    it "does not create the relationship if the current user already follows the leader" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      post :create, leader: bob
      expect(Relationship.all.count).to eq(1)
    end

    it "does not allow one to follow themselves" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, leader: alice
      expect(Relationship.all.count).to eq(0)
    end
  end

  describe "DELETE #destroy" do
    it_behaves_like "redirect_to_sign_in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "redirects to the people path" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "destroys the relationship if the current user is the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      delete :destroy, id: relationship
      expect(Relationship.all.count).to eq(0)
    end


    it "does not destroy the relationship if the current user is NOT the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      charles = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: charles)
      delete :destroy, id: relationship
      expect(Relationship.all.count).to eq(1)
    end
  end
end
