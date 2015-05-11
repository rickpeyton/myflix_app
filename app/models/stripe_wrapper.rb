module StripeWrapper
  class Charge
    attr_reader :error_message, :response

    def initialize(options = {})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
          :amount => options[:amount],
          :currency => "usd",
          :source => options[:source],
          :description => options[:description]
        )
      new(response: response) # This is the same as saying Charge.new(response)
        # it creates a new instance of the charge object
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
      # response does not need # because it is called through attr_reader
    end

    # This is not necessary because this is exactly what attr_reader does
    # def error_message
    #   @error_message
    # end

  end
end
