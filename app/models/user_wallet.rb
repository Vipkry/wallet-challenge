class UserWallet < ApplicationRecord
	belongs_to :user
	has_many :cards
	
	before_save :set_default_values
	before_update :set_custom_limit

	def credit_available
		total_spent = Card.where('user_wallet_id = ?', self.id).sum(:spent)
		credit_available = self.custom_limit - total_spent
		credit_available = 0 if credit_available < 0 # no need to show negative values to users
		return credit_available
	end

	def add_limit(value)
		self.update(:limit => self.limit + value)
	end

	def remove_limit(value)
		self.update(:limit => self.limit - value)
	end

	def spend(ammount)
		if ammount > self.credit_available
			# don't have enough money and/or has no card on the wallet
			errors.add(:limit, "No credit/card available for this purchase!")
			return false
		else
			# Select the card with the furthest due day
			# If there's a draw, select the one with more limit
			# One more thing, if the purchase extrapolates the credit of the designated card, choose another one to pay the rest using
			# the same criteria

			remaining_value = ammount

			# While there's money to be paid
			# it's safe to use while here because we just checked if there's enough credit
			while (remaining_value > 0)
				# === Get cards with furthest due day ===

				offset = 0
				offset = 30 - Date.today.day if (Date.today.month == 2) && (Date.today.day == 28 || Date.today.day == 29)
				

				cards = Card.where('user_wallet_id = ? and due_day < ?', self.id, Date.today.day).order('due_day DESC')
				winners = []
				2.times do
					cards.each do |card|
						# disconsider cards where the user already reached the limit
						if card.spent < card.limit
							if winners.empty? || winners.last.due_day == card.due_day
								winners << card
							else
								break
							end
						end
					end
					if winners.empty?
						cards = Card.where('user_wallet_id = ?', self.id).order('due_day DESC')
					else
						break
					end
				end

				return false if winners.empty? 

				winner = winners.first

				# === Check if there's a draw ===
				if winners.length > 1
					# === Choose the winner ===
					winners.each do |card|
						if winner.limit - winner.spent < card.limit - card.spent
							winner = card
						end
					end
				end

				# === Pay up ===
				winner_available_credit = winner.limit - winner.spent 
				final_value = winner_available_credit > remaining_value ? remaining_value : winner_available_credit
				if !winner.spend final_value
					errors.add(:limit, "Something went wrong (internal error).")
					return false
				end
				remaining_value  = remaining_value - winner_available_credit
			end

			return true
		end
	end	

	private 

		def set_default_values
			self.limit = 0 if self.limit.nil?
			self.custom_limit = self.limit if self.custom_limit.nil?
		end

		def set_custom_limit
			if self.limit < self.custom_limit
				self.custom_limit = self.limit
			elsif self.custom_limit < 0
				self.custom_limit = self.limit
			end
		end
end
