FactoryGirl.define do
  factory :otp do
    phone_number "9999999999"
    service "test_service"
    generated_at Time.now
  end
end