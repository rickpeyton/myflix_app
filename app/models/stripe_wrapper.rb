module StripeWrapper
  class Charge
    def self.create(options = {})
      Stripe.api_key = ENV['STRIPE_TEST_SECRET']
      Stripe::Charge.create(
        :amount => options[:amount],
        :currency => "usd",
        :source => options[:source],
        :description => options[:description]
      )
    end
  end
end
# module StripeWrapper
# 
#   class Charge
#     attr_reader :response
#     attr_reader :status
#     def initialize(response, status)
#       @response = response
#       @status = status
#     end
# 
#     def self.create(options = {})
#       Stripe.api_key = ENV['STRIPE_TEST_SECRET']
# 
#       begin
#         response = Stripe::Charge.create(
#           :amount => options[:amount], # amount in cents, again
#           :currency => "usd",
#           :source => options[:token],
#           :description => options[:description]
#         )
#         new(response, :success)
#       rescue Stripe::CardError => e
#         new(e, :danger)
#       end
#     end
# 
#     def successfull?
#       status == :success
#     end
# 
#     def error_message
#       response.message
#     end
#   end
# end
