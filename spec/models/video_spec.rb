require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#average_rating" do
    it "returns the average review for a given video rounded to 1
        decimal place" do
      video = Fabricate(:video)
      Fabricate(:review, rating: 4, video: video)
      Fabricate(:review, rating: 2, video: video)
      Fabricate(:review, rating: 2, video: video)
      expect(video.average_rating).to eq(2.7)
    end
  end

  describe "#search_by_title" do
    it "returns an empty array if there is no match" do
      walking_dead = Video.create(
        title: "The Walking Dead",
        description: "The Zombie Apocolypse")
      dead_man = Video.create(
        title: "Dead Man Walking",
        description: "This is not Real")
      Video.search_by_title("Futurama").should eq []
    end

    it "returns an array of one for an exact match" do
      walking_dead = Video.create(
        title: "The Walking Dead",
        description: "The Zombie Apocolypse")
      dead_man = Video.create(
        title: "Dead Man Walking",
        description: "This is not Real")
      Video.search_by_title("Dead Man Walking").should eq [dead_man]
    end

    it "returns an array of one for a partial match" do
      walking_dead = Video.create(
        title: "The Walking Dead",
        description: "The Zombie Apocolypse")
      dead_man = Video.create(
        title: "Dead Man Walking",
        description: "This is not Real")
      Video.search_by_title("king Dead").should eq [walking_dead]
    end

    it "returns an array of all matches ordered by created_at" do
      walking_dead = Video.create(
        title: "The Walking Dead",
        description: "The Zombie Apocolypse",
        created_at: 3.days.ago)
      dead_man = Video.create(
        title: "Dead Man Walking",
        description: "This is not Real")
      Video.search_by_title("alking").should eq [dead_man, walking_dead]
    end

    it "returns an empty array if the search string is empty" do
      walking_dead = Video.create(
        title: "The Walking Dead",
        description: "The Zombie Apocolypse",
        created_at: 3.days.ago)
      dead_man = Video.create(
        title: "Dead Man Walking",
        description: "This is not Real")
      Video.search_by_title("").should eq []
    end
  end
end
