require 'spec_helper'

describe QueueItemsController do
  context "authenticated user" do
    it "sets @queue_items variable for the logged in user" do
      user = Fabricate(:user, name: "John Doe")
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
  end
  context "non-authenticated user" do
    it "redirects to the sign-in page if not logged in" do
      get :index
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
