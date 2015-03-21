require 'spec_helper'

describe VideosController do

  describe "GET #show/:id" do
    context "an authenticated user" do
      before do
        set_current_user
        @video = Fabricate(:video)
        get :show, id: @video.id
      end

      it "assigns @video" do
        expect(assigns(:video)).to eq(@video)
      end

      it "assigns a new review object" do
        expect(assigns(:review)).to be_a_new(Review)
      end

      it "assigns @reviews for @video" do
        review1 = Fabricate(:review, video: @video)
        review2 = Fabricate(:review, video: @video)
        expect(assigns(:reviews)).to match_array([review2, review1])
      end
    end

    it_behaves_like "redirect_to_sign_in" do
      let(:action) { get :show, id: Fabricate(:video).id }
    end

  end

  describe "GET #search" do
    it "returns videos for an authenticated user" do
      set_current_user
      video = Fabricate(:video, title: "The Walking Dead")
      get :search, search_terms: "alking D"
      expect(assigns(:videos)).to match_array([video])
    end

    it_behaves_like "redirect_to_sign_in" do
      let(:action) { get :search, search_terms: "alking D" }
    end
  end

end
