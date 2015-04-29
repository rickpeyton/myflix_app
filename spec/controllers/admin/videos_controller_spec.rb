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

  describe "POST#create" do
    it_behaves_like "redirect_to_sign_in" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      before do
        set_current_admin
      end

      it "redirects to the add video page" do
        category = Fabricate(:category)
        post :create, video: { title: "Video Title", description: "Video Description", category_id: category.id }
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a new video" do
        category = Fabricate(:category)
        post :create, video: { title: "Video Title", description: "Video Description", category_id: category.id }
        expect(Video.all.count).to eq(1)
      end

      it "sets the flash message" do
        category = Fabricate(:category)
        post :create, video: { title: "Video Title", description: "Video Description", category_id: category.id }
        expect(flash[:success]).not_to be_nil
      end
    end

    context "with invalid input" do
      before do
        set_current_admin
      end

      it "renders the new template" do
        category = Fabricate(:category)
        post :create, video: { description: "Video Description", category_id: category.id }
        expect(response).to render_template :new
      end

      it "sets the video" do
        category = Fabricate(:category)
        post :create, video: { description: "Video Description", category_id: category.id }
        expect(:video).to be_present
      end

      it "sets the flash message" do
        category = Fabricate(:category)
        post :create, video: { description: "Video Description", category_id: category.id }
        expect(flash[:danger]).to be_present
      end
    end
  end
end
