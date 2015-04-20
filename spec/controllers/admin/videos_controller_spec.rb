require 'spec_helper'

describe Admin::VideosController do
  describe "GET #new" do
    let(:alice) { Fabricate(:user) }

    before do
      set_current_user(alice)
    end

    it "sets a new video instance" do
      alice.update_attribute(:admin, true)
      get :new
      expect(assigns(:video)).to be_an_instance_of(Video)
    end

    it "should restrict access to admins only" do
      get :new
      expect(response).to redirect_to sign_in_path
    end
  end
end
