require 'spec_helper'

describe QueueItemsController do
  describe "GET #index" do
    context "authenticated user" do
      it "sets @queue_items variable for the logged in user" do
        user = Fabricate(:user, name: "John Doe")
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, user: user)
        queue_item2 = Fabricate(:queue_item, user: user)
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end

      it "returns @queue_items in ascending order by position" do
        user = Fabricate(:user, name: "John Doe")
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, position: 2, user: user)
        queue_item2 = Fabricate(:queue_item, position: 1, user: user)
        get :index
        expect(assigns(:queue_items)).to eq([queue_item2, queue_item1])
      end
    end
    context "non-authenticated user" do
      it "redirects to the sign-in page if not logged in" do
        get :index
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  describe "POST #create" do
    context "authenticated user" do
      it "redirects to the user's my_queue" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        post :create, video_id: video.id, user_id: user.id
        expect(response).to redirect_to(my_queue_path)
      end

      it "sets the video to the logged in user's queue_items" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        post :create, video_id: video.id, user_id: user.id
        expect(user.queue_items.count).to eq(1)
      end

      it "sets the priority of the video to the end of the user's queue" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        video2 = Fabricate(:video)
        Fabricate(:queue_item, position: 1, user: user, video: video)
        post :create, video_id: video2.id, user_id: user.id
        expect(user.queue_items.last.position).to eq(2)
      end
    end
     context "non-authenticated user" do
       it "redirects to the sign-in page of not logged in" do
         session[:user_id] = nil
         user = Fabricate(:user)
         video = Fabricate(:video)
         post :create, video_id: video, user_id: user
         expect(response).to redirect_to sign_in_path
       end
     end
  end
end
