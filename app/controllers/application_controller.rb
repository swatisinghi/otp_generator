class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from (ActiveRecord::RecordNotFound) { |exception| handle_exception(exception, 404) }

   protected

    def handle_exception(ex, status)
    	logger.error("Error: #{ex}")
    	render :json => { :verfified => false }, :status => status
    end
end
