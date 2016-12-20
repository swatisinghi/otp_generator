require 'rails_helper'
require 'support/factory_girl'

RSpec.describe OtpController, :type => :controller do

  context "VERIFY otp" do

  	before do
	  #This entry is cleaned after the test run - see spec_helper.rb
	  @otp = create :otp
	end

    it "should return true and mark otp used if valid" do
      put :update, { :id => @otp.phone_number, :service => @otp.service, :otp => @otp.id }
      expect(response.status).to eq(200)
      expect(@otp.reload.used).to eq(true)
    end

    it "should return 422 if invalid" do
      put :update, { :id => @otp.phone_number, :service => @otp.service, :otp => 111 } #For now hard coding a incorrect id
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(422)
      expect(response_body["error_code"]).to eq(1)
      expect(response_body["error_message"]).to eq("Invalid OTP")
    end

    it "should return 422 if otp is already used" do
      @new_otp = create :otp, :used => true
      put :update, { :id => @new_otp.phone_number, :service => @new_otp.service, :otp => @new_otp.id }
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(422)
      expect(response_body["error_code"]).to eq(2)
      expect(response_body["error_message"]).to eq("OTP already used")
    end

    it "should return 422 if otp has expired" do
      @new_otp = create :otp, :generated_at => Time.now - 1000	
      put :update, { :id => @new_otp.phone_number, :service => @new_otp.service, :otp => @new_otp.id }
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(422)
      expect(response_body["error_code"]).to eq(3)
      expect(response_body["error_message"]).to eq("OTP expired")
    end

    it "should return 422 if request is malformed" do
      put :update, { :id => @otp.phone_number, :service => @otp.service }
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(422)
      expect(response_body["error_code"]).to eq(0)
      expect(response_body["error_message"]).to eq("Please send otp in request")
    end
  end

  context "POST create" do

  	before do
	  @phone_number  = 9999999999
	  @service = "forgot_password"
	end

    it "generates a new otp for phone number and subscription" do
      params = { phone_number: @phone_number, service: @service }
      post :create, params

      response_body = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response_body["otp"]).to be_a(Integer)

      #Verifying if a new entry in otp table is generated
      generated_opt = Otp.where(:id => response_body["otp"], :phone_number => @phone_number, :service => @service)
      expect(generated_opt.length).to eq(1)
    end

    it "throws error if phone_number is not in request" do
      params = { service: @service }
      post :create, params

      response_body = JSON.parse(response.body)
      expect(response.status).to eq(422)
      expect(response_body["errors"][0]).to eq("Phone number can't be blank")
    end

    it "throws error if caller service not in request" do
      params = { phone_number: @phone_number }
      post :create, params

      response_body = JSON.parse(response.body)
      expect(response.status).to eq(422)
      expect(response_body["errors"][0]).to eq("Service can't be blank")
    end
  end
end