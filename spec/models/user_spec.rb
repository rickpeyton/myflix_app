require 'spec_helper'

describe User do
  it { should have_secure_password }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items).order('position') }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_length_of(:password).is_at_least(8) }
end

