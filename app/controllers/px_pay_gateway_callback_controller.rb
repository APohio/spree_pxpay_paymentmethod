class PxPayGatewayCallbackController < ActionController::Base

  include Spree::Core::Engine.routes.url_helpers

  # Handles the response from PxPay (success or failure) and updates the
  # relevant Payment record. works with spree 2.1.7
  def callback
    response = Pxpay::Response.new(params).response.to_hash

    payment = Spree::Payment.find(response[:merchant_reference])
    order = payment.order

    if payment.checkout?

      if response[:success] == '1'
        payment.process!
        payment.response_code = response[:auth_code]
        payment.gateway_payload = response if payment.respond_to?(:gateway_payload)
        payment.save
        payment.complete

        order.state = 'complete'
        order.completed_at  = Time.now
        order.save

        order.deliver_order_confirmation_email
      else
        payment.void
        redirect_to cart_path, :notice => 'Your credit card details were declined. Please check your details and try again.'
        return
      end

    end

    flash.notice = Spree.t(:order_processed_successfully)
    redirect_to order_path(order, :token => order.token)
  end


end
