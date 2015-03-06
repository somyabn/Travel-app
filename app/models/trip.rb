class Trip
	require 'gas_station'
	attr_accessor :name, :start, :finish, :distance, :duration, :gas_stations, :mpg
	
	def initialize(name, start_place, finish_place, mpg)
		@name = name
		@start = start_place
		@finish = finish_place
		@mpg = mpg.to_f
		@gas_stations =[]
		self.get_distance_duration
    	self.get_gas_stations
	end

	def gas_price
		(@distance.gsub(",", "").to_f / @mpg) * self.return_cheapest_or_closest_gas_stations.first.price.to_f
	end

	
	def get_places_interest
		finish_lat = self.finish.latitude.to_s
		finish_lon = self.finish.longitude.to_s

		google_key = ENV['GOOGLE_DIRECTION_MATRIX_APIKEY']

	 	url ="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{finish_lat},#{finish_lon}&radius=50000&types=campground|rv_park&key=#{google_key}"


	 	response = JSON.load(RestClient.get(url))
	 	
		response["rows"][0]["elements"].map do |f|
			@distance = f["distance"]["text"]
		    @duration= f["duration"]["text"]
			end

	end


	def get_distance_duration
		google_key = ENV['GOOGLE_DIRECTION_MATRIX_APIKEY']
		
		origin = self.start.address
		dest = self.finish.address

	
		url ="https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{origin}&destinations=#{dest}&units=imperial&language=en-EN&key=#{google_key}"

	 	response = JSON.load(RestClient.get(url))
	 	# p "this is the response "
	 	# p  response
	 	# p "END"
	 	#  #p["rows"][0]["elements"][0]["status"]
					
		response["rows"][0]["elements"].map do |f|	
			@distance = f["distance"]["text"]
		    @duration= f["duration"]["text"]   
		end
	 end

	 def get_gas_stations
		start_lat = self.start.latitude.to_s
		start_lon = self.start.longitude.to_s
		gas_key = ENV['GASFEED_APIKEY']
		url = "http://api.mygasfeed.com/stations/radius/#{start_lat}/#{start_lon}/5/reg/price/#{gas_key}.json"

	 	response = JSON.load(RestClient.get(url))
	 	
		response["stations"].each do |f|
			price = f["reg_price"]
			name = f["station"]
			city = f["city"]
			distance = f["distance"]
			address = f["address"]
			self.gas_stations << GasStation.new(name, price, city, distance, address)
		 end
	 end


	 # return the GasStations with the lowest price
	 # or the closest station
	 def return_cheapest_or_closest_gas_stations
	 	cheapest = []
	 	closest = []
	 	self.gas_stations.each do |station|
	 		if closest.empty?
 				closest.push(station)
 			else
 				closest = [station] if station.distance.to_f < closest.first.distance.to_f
 			end 
	 		unless station.price == "N/A"
	 			if cheapest.empty?
	 				cheapest.push(station)
	 			else
	 				if station.price.to_f < cheapest.first.price.to_f
	 					cheapest = [station]
	 				elsif station.price.to_f == cheapest.first.price.to_f
	 					cheapest << station
	 				end
	 			end 
	 		end 
	 	end
	 	cheapest.empty? ? closest : cheapest 
	 end


end