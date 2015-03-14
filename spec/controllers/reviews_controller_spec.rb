require 'spec_helper'

describe ReviewsController do
  describe "POST #create" do
    context "an authenticated user" do
      let(:current_user) { Fabricate(:user, name: "Rick") }

      before do
        session[:user_id] = current_user
        @walking = Fabricate(:video, title: "The Walking Dead")
      end

      context "with valid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review),
               video_id: @walking.id
        end

        it "redirects to the video show page" do
          expect(response).to redirect_to video_path(@walking)
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do
          expect(Review.first.video).to eq(@walking)
        end

        it "creates a review associates with the user" do
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review, description: nil), video_id: @walking.id
        end

        it "does not create a review" do
          expect(Review.count).to eq(0)
        end

        it "renders the video show template" do
          expect(response).to render_template "videos/show"
        end

        it "sets @video" do
          expect(assigns(:video)).to eq(@walking)
        end

        it "sets @reviews" do
          expect(assigns(:reviews)).to match_array(@walking.reviews)
        end
      end
    end

    context "a non-authenticated user" do

      it "redirects to the sign-in path" do
          @walking = Fabricate(:video, title: "The Walking Dead")
          post :create, review: Fabricate.attributes_for(:review),
               video_id: @walking.id
          expect(response).to redirect_to sign_in_path
      end

    end
  end
end
