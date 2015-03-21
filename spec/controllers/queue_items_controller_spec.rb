require 'spec_helper'

describe QueueItemsController do

  describe "GET #index" do
    context "authenticated user" do
      it "sets @queue_items variable for the logged in user" do
        user = Fabricate(:user, name: "John Doe")
        set_current_user(user)
        Fabricate(:queue_item, user: user)
        Fabricate(:queue_item, user: user)
        get :index
        expect(assigns(:queue_items)).to eq(user.queue_items)
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

      it "redirects to the my_queue page" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        post :create, video_id: video.id, user_id: user.id
        expect(response).to redirect_to(my_queue_path)
      end

      it "creates a queue item" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video, title: "Polar Express")
        post :create, video_id: video.id, user_id: user.id
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue item associated with the user" do
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
        expect(user.queue_items.find_by(position: 2).video).to eq(video2)
      end

      it "does not add a video that is already in user queue" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        Fabricate(:queue_item, position: 1, user: user, video: video)
        post :create, video_id: video.id, user_id: user.id
        expect(user.queue_items.count).to eq(1)
      end

      it "does add a video that is already in another users queue" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        user2 = Fabricate(:user)
        Fabricate(:queue_item, position: 1, user: user2, video: video)
        post :create, video_id: video.id, user_id: user.id
        expect(user.queue_items.count).to eq(1)
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

  describe "DELETE #destroy" do
    it "redirects to the users my_queue" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item
      expect(response).to redirect_to my_queue_path
    end

    it "removes the queue-item" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item
      expect(QueueItem.all.count).to eq(0)
    end

    it "only removes queue-item owned by the user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item
      expect(bob.queue_items.count).to eq(1)
    end

    it "reorders the items in the queue" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      item1 = Fabricate(:queue_item, user: alice, position: 1)
      item2 = Fabricate(:queue_item, user: alice, position: 2)
      delete :destroy, id: item1.id
      expect(item2.reload.position).to eq(1)
    end

    it "redirects to the sign-in page for a non-authenticated user" do
      delete :destroy, id: 1
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST #update_my_queue" do
    context "with valid inputs" do
      it "redirects to my_queue" do
        alice = Fabricate(:user, name: "Alice")
        session[:user_id] = alice.id
        post :update_my_queue, id: alice.id, queue_items: []
        expect(response).to redirect_to(my_queue_path)
      end

      it "Updates the position of the queue items" do
        alice = Fabricate(:user, name: "Alice")
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
        put :update_my_queue, id: alice.id, queue_items: [
          {id: "#{queue_item1.id}", position: "2"},
          {id: "#{queue_item2.id}", position: "1"}]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        alice = Fabricate(:user, name: "Alice")
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
        put :update_my_queue, id: alice.id, queue_items: [{id: "#{queue_item1.id}", position: "3"}, {id: "#{queue_item2.id}", position: "2"}]
        expect(alice.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do
      it "redirects to my queue" do
        alice = Fabricate(:user, name: "Alice")
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
        put :update_my_queue, id: alice.id, queue_items: [{id: "#{queue_item1.id}", position: "3"}, {id: "#{queue_item2.id}", position: "2.5"}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash message" do
        alice = Fabricate(:user, name: "Alice")
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
        put :update_my_queue, queue_items: [{id: "#{queue_item1.id}", position: "3"}, {id: "#{queue_item2.id}", position: "2.5"}]
        expect(flash[:danger]).not_to be_empty
      end

      it "does not change the order of the queue items" do
        alice = Fabricate(:user, name: "Alice")
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
        put :update_my_queue, queue_items: [{id: "#{queue_item1.id}", position: "3"}, {id: "#{queue_item2.id}", position: "2.5"}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to the sign-in page" do
        alice = Fabricate(:user, name: "Alice")
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
        put :update_my_queue, queue_items: [{id: "#{queue_item1.id}", position: "3"}, {id: "#{queue_item2.id}", position: "2.5"}]
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with queue items that do not belong to the current user" do
      it "does not update the queue items for Bob" do
        alice = Fabricate(:user, name: "Alice")
        bob = Fabricate(:user, name: "Bob")
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1)
        queue_item2 = Fabricate(:queue_item, user: bob, position: 2)
        put :update_my_queue, queue_items: [{id: "#{queue_item1.id}", position: "3"}, {id: "#{queue_item2.id}", position: "2"}]
        expect(bob.queue_items).to eq([queue_item1, queue_item2])
      end
    end

    context "with video ratings" do
      it "updates the rating for a video that already had a rating" do
        alice = Fabricate(:user, name: "Alice")
        session[:user_id] = alice.id
        video = Fabricate(:video)
        Fabricate(:review, rating: 3, user: alice, video: video)
        queue_item1 = Fabricate(:queue_item, user: alice, video: video, position: 1)
        put :update_my_queue, queue_items: [{
          id: "#{queue_item1.id}",
          position: "#{queue_item1.id}",
          rating: "5"}]
        expect(User.first.reviews.first.rating).to eq(5)
      end

      it "adds a rating for a video that does not already have a rating" do
        alice = Fabricate(:user, name: "Alice")
        session[:user_id] = alice.id
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: alice, video: video, position: 1)
        put :update_my_queue, queue_items: [{
          id: "#{queue_item.id}",
          position: "#{queue_item.position}",
          rating: "5"}]
        expect(User.first.reviews.first.rating).to eq(5)
      end

    end
  end

end
