class AuthenticateUser
	prepend SimpleCommand 
	
	def initialize(id_nat, password)
		@id_nat = id_nat
		@password = password 
	end 

	def call 
	 JsonWebToken.encode(user_id: user.id) if user 
	end 

	private 

		attr_accessor :id_nat, :password

	  def user
		  user = User.find_by(id_nat: id_nat) 
		  if user && user.authenticate(password)
				return user
			else
			  errors.add :user_authentication, 'Invalid credentials.' 
			  return nil
			end
		end 
end