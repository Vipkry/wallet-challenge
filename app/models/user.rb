class User < ApplicationRecord

	has_secure_password

	validates :name, presence: true
	validates :id_nat, presence: true

	def self.new_token
		SecureRandom.urlsafe_base64
	end
end