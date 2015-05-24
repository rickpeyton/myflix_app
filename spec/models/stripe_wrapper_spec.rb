require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 5,
        :exp_year => 2019,
        :cvc => "314"
      },
    ).id
  end

  let(:decline_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 5,
        :exp_year => 2019,
        :cvc => "314"
      },
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => valid_token,
          :description => "Stripe Wrapper Model Test Charge"
        )
        expect(response).to be_successful
      end

      it "makes a card declined charge", :vcr do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => decline_token,
          :description => "Stripe Wrapper Model Decline Test"
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => decline_token,
          :description => "Stripe Wrapper Model Decline Test"
        )
        expect(response.error_message).to eq "Your card was declined."
      end

    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )
        expect(response).to be_successful
      end

      it "does not create a customer with a declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: decline_token
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for a declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: decline_token
        )
        expect(response.error_message).to eq "Your card was declined."
      end

      it "returns the customer token for a valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )
        expect(response.customer_token).to be_present
      end
    end
  end
end
