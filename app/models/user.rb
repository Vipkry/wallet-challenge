class User < ApplicationRecord
	has_one :user_wallet

	has_secure_password

	validates :name, presence: true
	validates :id_nat, presence: true, uniqueness: true

	before_save :set_default_values

	def self.new_token
		SecureRandom.urlsafe_base64
	end

	def check_token(login_token)
		return self.login_token == login_token
	end

	private 

		def set_default_values
			self.login_token = User.new_token if self.login_token.nil?
		end

end