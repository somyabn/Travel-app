class Trip
	require 'gas_station'
	attr_accessor :name, :start, :finish, :distance, :duration, :gas_stations
	def initialize(name)
		@name = name
		# @gas_prices =[]
		@gas_stations =[]

	end



	def get_distance_duration(origin, dest)
	
		url ='https://maps.googleapis.com/maps/api/distancematrix/json?origins= ' + origin + '&destinations='+ dest + '&units=imperial&language=en-EN&key=AIzaSyAx-1mSSyPiZeczW_pdW5BHU3Zv1pdhvgs'

	 	response = JSON.load(RestClient.get(url))
	 	# @url = response["link"]
	 	# @title = response["title"]

	
		response["rows"][0]["elements"].map do |f|
			@distance = f["distance"]["text"].to_f
		    @duration= f["duration"]["text"]
			end
	 end

	 def get_gas_stations
		start_lat = self.start.latitude.to_s
		start_lon = self.start.longitude.to_s

		url ='http://api.mygasfeed.com/stations/radius/' + start_lat + '/' + start_lon +'/5/reg/price/5rj3qcr3ty.json'

	 	response = JSON.load(RestClient.get(url))
	 	# @url = response["link"]
	 	# @title = response["title"]

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