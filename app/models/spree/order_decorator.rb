Spree::Order.class_eval do

  # Override this method to do nothing, as no payments will need to be processed
  def process_payments!
  end

end
