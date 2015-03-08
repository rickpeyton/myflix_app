require 'spec_helper'

describe Category do

  it { should have_many(:videos).order(:title) }

  describe "recent_videos" do
  end
end
