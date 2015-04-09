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
end
