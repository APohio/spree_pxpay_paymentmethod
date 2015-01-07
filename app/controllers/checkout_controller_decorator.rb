Spree::CheckoutController.class_eval do

  private

  alias :before_payment_without_px_pay_redirection :before_payment

  def before_payment
    before_payment_without_px_pay_redirection
    redirect_to px_pay_gateway.url(@order, request)
  end

  def px_pay_gateway
    @order.available_payment_methods.find { |x| x.is_a?(Spree::Gateway::PxPay) }
  end

end
