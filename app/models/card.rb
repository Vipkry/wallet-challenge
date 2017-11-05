class Card < ApplicationRecord
	belongs_to :user_wallet 

	before_save :set_expiration

	attr_accessor :expiration_month
	attr_accessor :expiration_year

	private
		def set_expiration
			if expiration_month && expiration_month
				# sets date to the last day of the chosen month
				self.expiration_date = Date.new(expiration_year.to_i, expiration_month.to_i, -1)
			end
		end

end
