require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position) }

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

