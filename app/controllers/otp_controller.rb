
include OtpHelper

class OtpController < ApplicationController
  
  def create
  	otp = Otp.new(:phone_number => params[:phone_number], :service => params[:service], :generated_at => Time.now)
  	if otp.save
  	  render :json => { :otp => otp.id }
  	else
  	  render :json => { :errors => otp.errors.full_messages }, :status => 422
  	end
  end

  #For now hardcoding the error code, later we can put 
  #them all together in a file containg error codes and corresponding
  def update
	[:otp, :service].each do |p|
  	  render :json => { :error_code => 0, :error_message => "Please send #{p} in request" }, :status => 422 and return if !params.has_key?(p)
  	end
  	
  	error, error_message = validate_otp
  	if error 
  	  render :json => error_message, :status => 422 
  	else 
  	  render :nothing => true 
  	end
  end
end
