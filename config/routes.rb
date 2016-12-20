OtpGenerator::Application.routes.draw do

  resources :otp
    get "otp/index"
    get 'otp/:otp/phone_number/:phone_number/service/:service' => 'otp#verify'
end
