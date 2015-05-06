require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        Stripe.api_key = ENV['STRIPE_TEST_SECRET']
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 5,
            :exp_year => 2019,
            :cvc => "314"
          },
        ).id

        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => token,
          :description => "Stripe Wrapper Model Test Charge"
        )

        expect(response.amount).to eq 999
        expect(response.currency).to eq "usd"
      end
    end
  end
end
