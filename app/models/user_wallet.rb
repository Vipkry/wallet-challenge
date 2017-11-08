class UserWallet < ApplicationRecord
	belongs_to :user
	has_many :cards
	
	before_save :set_default_values
	before_update :check_custom_limit

	private 

		def set_default_values
			self.limit = 0 if self.limit.nil?
			self.custom_limit = 0 if self.custom_limit.nil?
		end

		def check_custom_limit
			if self.limit < self.custom_limit
				self.custom_limit = self.limit
			end
		end
end
