Rails.application.routes.draw do
  get '/checkout/pay/callback' => 'px_pay_gateway_callback#callback'
end
