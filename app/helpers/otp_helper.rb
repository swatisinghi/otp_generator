module OtpHelper
  def validate_otp
    error_message = ""
	error = false
	otp = Otp.where(:id => params[:otp].to_i, :phone_number => params[:id].to_s, :service => params[:service])
	if otp.empty?
	  error_message = { :error_code => 1, :error_message => "Invalid OTP" }
	  error = true
	elsif otp.first.used
	  error_message = { :error_code => 2, :error_message => "OTP already used" }
	  error = true
	else
      #For now just hard coding 300 seconds
      expired = (Time.now  - otp.first.generated_at) > 300
  	  if expired
        error_message = { :error_code => 3, :error_message => "OTP expired" }
        error = true
  	  else		
  	    otp = otp.first
  	    otp.used = true
  	    otp.save!
	  end
    end
    return error, error_message
  end
end
