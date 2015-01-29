
payment_method = Spree::Gateway::PxPay.first

if payment_method && payment_method.preferred_user_id.present? && payment_method.preferred_key.present?
  Pxpay::Base.pxpay_user_id = payment_method.preferred_user_id
  Pxpay::Base.pxpay_key = payment_method.preferred_key
else
  Rails.logger.error('spree_pxpay_paymentmethod gem: No payment method found for Spree::Gateway::PxPay. Cannot set Pxpay::Base user_id and key values. Please set these values in the Spree Admin Payment Methods section.')
end
