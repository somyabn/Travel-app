class GasStation
	attr_accessor :name, :price, :city, :distance, :address
	def initialize(name, price, city, distance, address)
		@name = name
		@price = price
		@city =city
		@distance = distance
		@address = address
	end


end