require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#set_queue_position" do
    context "there are other videos in the queue" do
      it "returns the last position plus one for user1" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        Fabricate(:queue_item, position: 1, user: user1, video: video1)
        Fabricate(:queue_item, position: 2, user: user1, video: video2)
        Fabricate(:queue_item, position: 1, user: user2, video: video2)
        queue_item4 = Fabricate(:queue_item, user: user2, video: video1)
        expect(queue_item4.set_queue_position).to eq(2)
      end
    end

    context "there are NOT other videos in the queue" do
      it "returns 1" do
        user1 = Fabricate(:user)
        video1 = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: user1, video: video1)
        expect(queue_item.set_queue_position).to eq(1)
      end
    end
  end

  describe "#video_title" do
    it "returns the video title of the queue item" do
      video = Fabricate(:video, title: "The Walking Dead")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("The Walking Dead")
    end
  end

  describe "#rating" do
    it "returns the user review rating for the queue_item" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      Fabricate(:review, rating: 2, user: user, video: video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(2)
    end
    it "returns nil if there is no user review rating for the queue_item" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do
    it "returns the category name that the queue_item video belongs to" do
      category = Fabricate(:category, name: "Drama")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Drama")
    end
  end

  describe "#category" do
    it "returns the category object for the queue_item video it belongs to" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(video.category)
    end
  end
end

