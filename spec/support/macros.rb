def set_current_user(user = nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(admin = nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def generate_token
  Stripe.api_key = ENV['STRIPE_TEST_SECRET']

  token = Stripe::Token.create(
    :card => {
      :number => "4242424242424242",
      :exp_month => 5,
      :exp_year => 2016,
      :cvc => "314"
    },
  )

  token.id
end

def generate_decline_token
  Stripe.api_key = ENV['STRIPE_TEST_SECRET']

  token = Stripe::Token.create(
    :card => {
      :number => "4000000000000002",
      :exp_month => 5,
      :exp_year => 2016,
      :cvc => "314"
    },
  )

  token.id
end
