FactoryGirl.define do
  factory :otp do
    phone_number "9999999999"
    service "test_service"
    used false
    generated_at Time.now
  end
end