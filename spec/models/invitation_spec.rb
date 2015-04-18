require 'spec_helper'

describe Invitation do
  it do
    should allow_value('foo.bar@example.com', 'foo2@bar.net').
      for(:friend_email)
  end

  it do
    should_not allow_value('foo.bar2example.com', 'foo@bar>com').
      for(:friend_email)
  end

  it { should validate_presence_of :friend_email }
  it { should validate_presence_of :friend_name }
  it { should validate_presence_of :message }

  it_behaves_like "tokenable" do
    let(:object) { Invitation.create(friend_email: "foo@bar.com", friend_name: "Bob", message: "message") }
  end
end

