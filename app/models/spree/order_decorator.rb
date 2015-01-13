Spree::Order.class_eval do

  # Override this method to do nothing, as no payments will need to be processed
  def process_payments!
    Rails.logger.info('process_payments! has been overridden by spree_pxpay_paymentmethod gem to do nothing')
  end

end
