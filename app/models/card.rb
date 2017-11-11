class Card < ApplicationRecord
	belongs_to :user_wallet

	validates :name, length: {in: 0..35}, allow_blank: true
	validates :name_written, length: {in: 4..100}, presence: true
	validates :number, length: {in: 10..40}, presence: true, numericality: { only_integer: true }

	validates :due_day, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 31}, on: :create
	validates :expiration_year, presence: true, numericality: { only_integer: true, greater_than: 2016}, on: :create
	validates :expiration_month, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 13}, on: :create

	validates :cvv, presence: true, numericality: { only_integer: true, greater_than: 0 }
	validates :limit, presence: true, numericality: { greater_than: 0 }

	validate  :spent_cant_be_higher_than_limit

	before_save :set_expiration
	before_validation :set_default_values

	# expiration attr_acessor so it makes the input of these values easier
	attr_accessor :expiration_month
	attr_accessor :expiration_year

	def hide_confidencial_info
		# only show the last 4 digits of the card
		number = self.number
		number.reverse!
		number = number.slice(0..3)
		number.reverse!
		self.number = "**********" +  number

		# don't show the cvv
		self.cvv = 0
	end

	def spend(ammount)
		self.update(:spent => self.spent + ammount)
	end

	private
		def set_expiration
			if expiration_month && expiration_year
				# sets date to the last day of the chosen month
				self.expiration_date = Date.new(expiration_year.to_i, expiration_month.to_i, -1)
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

		def spent_cant_be_higher_than_limit
			if !self.limit.nil? && self.spent > self.limit
				errors.add(:spent, "Can't spend more than the limit!")
			end
		end

end
