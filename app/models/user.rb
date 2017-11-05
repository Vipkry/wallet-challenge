class User < ApplicationRecord
	has_one :user_wallet

	has_secure_password

	validates :name, presence: true
	validates :id_nat, presence: true, uniqueness: true

end