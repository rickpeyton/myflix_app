require 'spec_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_1663t9Bqa7wW343mv00CcMTd",
      "created" => 1432492315,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_1663t9Bqa7wW343mcadnZpD8",
          "object" => "charge",
          "created" => 1432492315,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_1663slBqa7wW343m2H97m8Zm",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 5,
            "exp_year" => 2029,
            "fingerprint" => "ZhVFbAJzD8pN8efH",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6IYCqcL6kWfQbR"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_6IYCqcL6kWfQbR",
          "invoice" => nil,
          "description" => "Test Payment Failure",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "destination" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_1663t9Bqa7wW343mcadnZpD8/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_6IfDIgrYgo2dXy",
      "api_version" => "2015-04-07"
    }
  end

  it "deactivates the user based on the webhook data from stripe for a charged failed", :vcr do
    alice = Fabricate(:user, customer_token: "cus_6IYCqcL6kWfQbR")
    post "/stripe-events", event_data
    expect(alice.reload).not_to be_active
  end
end
