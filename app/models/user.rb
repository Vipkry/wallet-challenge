class User < ApplicationRecord
	has_one :user_wallet

	has_secure_password

	validates :name, presence: true, length: {in: 4..80}
	validates :id_nat, presence: true, uniqueness: true, numericality: { only_integer: true }


end