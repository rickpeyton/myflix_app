require 'spec_helper'

describe UserSignup do

  describe "#sign_up" do
    context "with valid personal info and valid card info" do
      let(:customer) { double(successful?: true, customer_token: "abcdefg") }

      before do
        expect(StripeWrapper::Customer).to receive(:create) { customer }
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up(
          "fake_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "stores the customer token from Stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up(
          "fake_stripe_token", nil)
        expect(User.first.customer_token).to eq("abcdefg")
      end

      it "creates a relationship between invitee and invitor" do
        alice = Fabricate(:user)
        invite = Fabricate(:invitation, user_id: alice.id)
        UserSignup.new(Fabricate.build(:user)).sign_up(
          "fake_stripe_token", invite.token)
        expect(Relationship.where(["leader_id = ? and follower_id = ?",
                                   alice.id, User.last.id]).count).to eq(1)
      end

      it "creates a relationship between invitor and invitee" do
        alice = Fabricate(:user)
        invite = Fabricate(:invitation, user_id: alice.id)
        UserSignup.new(Fabricate.build(:user)).sign_up(
          "fake_stripe_token", invite.token)
        expect(Relationship.where(["leader_id = ? and follower_id = ?",
                                   User.last.id, alice.id]).count).to eq(1)
      end


      it "sends to the right recipient" do
        UserSignup.new(Fabricate.build(:user)).sign_up(
          "fake_stripe_token", nil)
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq([User.first.email])
      end

      it "contains the correct message" do
        UserSignup.new(Fabricate.build(:user)).sign_up(
          "fake_stripe_token", nil)
        email = ActionMailer::Base.deliveries.last
        expect(email.body).to include("Welcome to MyFlix")
      end
    end

    context "valid personal info and declined card" do
      let(:customer) { double(:customer, successful?: false,
                            error_message: "Your card was declined") }

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "does not create a new user record" do
        expect(StripeWrapper::Customer).to receive(:create) { customer }
        UserSignup.new(Fabricate.build(:user)).sign_up("fake_stripe_token", nil)
        expect(User.count).to eq 0
      end
    end

    context "invalid personal info" do
      after do
        ActionMailer::Base.deliveries.clear
      end

      it "does not create a user" do
        UserSignup.new(User.new(email: "john@example.com")).sign_up("fake_stripe_token", nil)
        expect(User.count).to eq 0
      end

      it "does not charge the card" do
        expect(StripeWrapper::Customer).not_to receive(:create) { customer }
        UserSignup.new(User.new(email: "john@example.com")).sign_up(
          "fake_stripe_token", nil)
      end

      it "does not send out the email with invalid inputs" do
        UserSignup.new(User.new(email: "john@example.com")).sign_up(
          "fake_stripe_token", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
