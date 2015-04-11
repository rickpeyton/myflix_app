require 'spec_helper'

describe User do
  it { should have_secure_password }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should have_many(:queue_items).order('position') }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_length_of(:password).is_at_least(8) }

  describe "#follows?" do
    it "returns true if a user already follows another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.follows?(bob)).to be_truthy
    end

    it "returns false if a user does not already follow another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      expect(alice.follows?(bob)).to be_falsey
    end
  end
end

