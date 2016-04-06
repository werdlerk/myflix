require 'spec_helper'

describe 'Deactive user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_17xMlKFdcisUpWXb5Srat0ot",
      "object" => "event",
      "api_version" => "2016-02-03",
      "created" => 1459972586,
      "data" => {
        "object" => {
          "id" => "ch_17xMlKFdcisUpWXbEgj1Ur0G",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1459972586,
          "currency" => "usd",
          "customer" => "cus_8Dmj3tsm2zfZgd",
          "description" => "payment to fail",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {
          },
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {
          },
          "order" => nil,
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [

            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_17xMlKFdcisUpWXbEgj1Ur0G/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_17xMkhFdcisUpWXbOPxAsfCz",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_8Dmj3tsm2zfZgd",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 4,
            "exp_year" => 2017,
            "fingerprint" => "qGYqEeiK0dZbPzYn",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => nil,
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_8DoOz0LKYGx0Cn",
      "type" => "charge.failed"
    }
  end

  it 'deactivates a user with the web hook data from Stripe for a charge failed', :vcr do
    alice = Fabricate(:user, stripe_customer_id: "cus_8Dmj3tsm2zfZgd")

    post "/_stripe_events", event_data

    expect(alice.reload).not_to be_active
  end


end

