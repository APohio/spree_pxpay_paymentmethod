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
        payment.save
        payment.complete

        unless order.next
          flash[:error] = order.errors[:base].join("\n")
          redirect_to checkout_state_path(order.state) and return
        end

        if order.complete?
          order.reload
          order.update!
        end

      else
        payment.void
        redirect_to cart_path, :notice => 'Your credit card details were declined. Please check your details and try again.'
        return
      end

    end

    session[:order_id] = nil
    flash.notice = Spree.t(:order_processed_successfully)
    flash[:commerce_tracking] = "nothing special"
    redirect_to order_path(order)
  end


end
