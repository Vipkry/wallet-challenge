class UserWallet < ApplicationRecord
	belongs_to :user

	before_save :set_default_values


	def set_default_values
		self.limit = 0 if self.limit.nil?
		self.custom_limit = 0 if self.custom_limit.nil?
	end

end
