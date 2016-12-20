class OtpController < ApplicationController
  
  def create
  	otp = Otp.new(:phone_number => params[:phone_number], :service => params[:service], :generated_at => Time.now)
  	if otp.save
  	  render :json => { :otp => otp.id }
  	else
  	  render :json => { :errors => otp.errors.full_messages }, :status => 422
  	end
  end

  #Decide the API structure with q or in the url and accordingly get rid of the below check
  def verify
  	[:phone_number, :service, :otp].each do |p|
  	  render :json => { :errors => "Please pass param #{p}" }, :status => 422 if !params.has_key?(p)
  	end
  	
  	#since we are using primary key (id) to query the table the query will be very fast	
  	otp = Otp.where(:id => params[:otp].to_i, :phone_number => params[:phone_number], :service => params[:service])
  	
  	if otp.empty?
  	  render :json => { :verfified => false }
  	else
	  #For now just hard coding 300 seconds
	  verified = (Time.now  - otp.first.generated_at) < 300
	  render :json => { :verfified => verified }
  	end
  end
end
