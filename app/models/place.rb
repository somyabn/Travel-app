class Place
	attr_accessor :address, :latitude, :longitude
	def initialize(address)
		@address = address
		result = Geocoder.coordinates(address)
		@latitude = result[0]
		@longitude = result[1]
	end
end