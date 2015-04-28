require 'spec_helper'

describe Admin::VideosController do
  describe "GET #new" do
    let(:alice) { Fabricate(:user) }

    before do
      set_current_user(alice)
    end

    it_behaves_like "redirect_to_sign_in" do
      let(:action) { get :new }
    end

    it "sets a new video instance" do
      session[:user_id] = nil
      set_current_admin
      get :new
      expect(assigns(:video)).to be_an_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end

    it "redirects the regular user to the home path" do
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets the flash danger message for the regular user" do
      get :new
      expect(flash[:danger]).not_to be_nil
    end
  end
end
