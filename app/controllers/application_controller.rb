class ApplicationController < ActionController::API

	before_action :authenticate

	private

		def authenticate
			@current_user = AuthorizeApiRequest.call(request.headers).result
			render json: { error: 'Not Authorized' }, status: 401 unless @current_user 
		end

end
