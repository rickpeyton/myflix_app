require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
   {
      "id" => "evt_165vqFBqa7wW343mw0mkhmrd",
      "created" => 1432461383,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_165vqFBqa7wW343mZuj82FNw",
          "object" => "charge",
          "created" => 1432461383,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_165vqEBqa7wW343mEHyPCMCf",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 5,
            "exp_year" => 2015,
            "fingerprint" => "f7lTnKnFL3fT6hHF",
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
            "customer" => "cus_6IWux8bsqss7oz"
          },
          "captured" => true,
          "balance_transaction" => "txn_165vqFBqa7wW343mIjLIGf4x",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_6IWux8bsqss7oz",
          "invoice" => "in_165vqEBqa7wW343mtbt2tGI0",
          "description" => nil,
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
            "url" => "/v1/charges/ch_165vqFBqa7wW343mZuj82FNw/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_6IWunoEFLroD2Q",
      "api_version" => "2015-04-07"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe-events", event_data
    expect(Payment.all.count).to eq 1
  end

  it "creates the payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_6IWux8bsqss7oz")
    post "/stripe-events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    Fabricate(:user, customer_token: "cus_6IWux8bsqss7oz")
    post "/stripe-events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    Fabricate(:user, customer_token: "cus_6IWux8bsqss7oz")
    post "/stripe-events", event_data
    expect(Payment.first.reference_id).to eq("ch_165vqFBqa7wW343mZuj82FNw")
  end
end
