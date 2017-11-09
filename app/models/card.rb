class Card < ApplicationRecord
	belongs_to :user_wallet

	validates :name, length: {in: 0..35}, allow_blank: true
	validates :name_written, length: {in: 4..100}, presence: true
	validates :number, length: {in: 10..40}, presence: true, numericality: { only_integer: true }

	validates :due_date_day, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 31}
	validates :expiration_year, presence: true, numericality: { only_integer: true, greater_than: 2016}
	validates :expiration_month, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 13}

	validates :cvv, presence: true, numericality: { only_integer: true, greater_than: 0 }
	validates :limit, presence: true, numericality: { greater_than: 0 }

	before_save :set_expiration
	before_save :set_due_date
	before_save :set_default_values

	# expiration attr_acessor so it makes the input of these values easier
	attr_accessor :expiration_month
	attr_accessor :expiration_year
	# due date attr_acessor so it makes the input of these values easier
	attr_accessor :due_date_day

	private
		def set_expiration
			if expiration_month && expiration_year
				# sets date to the last day of the chosen month
				self.expiration_date = Date.new(expiration_year.to_i, expiration_month.to_i, -1)
			end
		end

		def set_due_date
			if due_date_day
				# sets date to the actual year (year won't make any difference here)
				self.due_date = Date.new(Date.today.year, Date.today.month, due_date_day.to_i)
			end
		end

		def set_default_values
			# set default name
			if self.name.nil? || self.name.empty?
				self.name = "Card"
			end

			# set initial spent value
			if self.spent.nil?
				self.spent = 0
			end
		end

end
