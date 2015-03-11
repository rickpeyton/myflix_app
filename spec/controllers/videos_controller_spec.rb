require 'spec_helper'

describe VideosController do

  describe "GET #show/:id" do
    it "assigns @video to an authenticated user" do
      session[:user_id] = Fabricate(:user)
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "redirects to the sign in page if not authenticated" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET #search" do
    it "returns videos for an authenticated user" do
      session[:user_id] = Fabricate(:user)
      video = Fabricate(:video, title: "The Walking Dead")
      get :search, search_terms: "alking D"
      expect(assigns(:videos)).to match_array([video])
    end

    it "redirects to sign in page if not authenticated" do
      video = Fabricate(:video, title: "The Walking Dead")
      get :search, search_terms: "alking D"
      expect(response).to redirect_to sign_in_path
    end
  end

end
