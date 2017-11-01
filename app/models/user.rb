class User < ApplicationRecord

	has_secure_password

	def new_token
		SecureRandom.urlsafe_base64
	end
end