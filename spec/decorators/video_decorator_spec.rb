require 'spec_helper'

describe VideoDecorator do
  context "with a valid rating" do
    it "returns a string containing a valid rating" do
      Fabricate(:video)
      2.times do
        Fabricate(:review, video: Video.first)
      end
      @video = Video.first.decorate
      expect(@video.rating).to eq "Rating: #{@video.average_rating}/5.0"
    end
  end

  context "with no rating" do
    it "returns a string saying there is no rating" do
      Fabricate(:video)
      @video = Video.first.decorate
      expect(@video.rating).to eq "Rating: Not Yet Rated"
    end
  end
end
