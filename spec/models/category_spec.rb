require 'spec_helper'

describe Category do

  it { should have_many(:videos).order(created_at: :desc) }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    it "returns vidoes descending by created_at" do
      category = Category.create(name: "TV Dramas")
      walking_dead_1 = Video.create(
        title: "The Walking Dead 1",
        description: "Zombie Killers",
        category: category,
        created_at: 2.days.ago)
      walking_dead_2 = Video.create(
        title: "The Walking Dead 2",
        description: "Zombie Killers",
        category: category,
        created_at: 1.days.ago)
      expect(category.recent_videos).to eq([walking_dead_2, walking_dead_1])
    end

    it "returns all videos if there are less than 6" do
      category = Category.create(name: "TV Dramas")
      2.times do
        Video.create(
          title: "The Walking Dead",
          description: "Zombie Killers",
          category: category,
          created_at: 2.days.ago)
      end
      expect(category.recent_videos.count).to eq(2)
    end

    it "returns 6 videos if there are more than 6" do
      category = Category.create(name: "TV Dramas")
      7.times do
        Video.create(
          title: "The Walking Dead",
          description: "Zombie Killers",
          category: category,
          created_at: 2.days.ago)
      end
      expect(category.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      category = Category.create(name: "TV Dramas")
      6.times do
        Video.create(
          title: "The Walking Dead",
          description: "Zombie Killers",
          category: category,
          created_at: 2.days.ago)
      end
      forever = Video.create(
        title: "Forever",
        description: "Dude never dies",
        category: category,
        created_at: 3.days.ago)
      expect(category.recent_videos).not_to include(forever)
    end

    it "returns an empty array if the category has no videos" do
      category = Category.create(name: "TV Dramas")
      expect(category.recent_videos).to eq([])
    end
  end
end
