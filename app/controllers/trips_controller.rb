class TripsController < ApplicationController
  
  def new

  end
 
  def show
  	start_place = Place.new(params[:start_address])
    end_place = Place.new(params[:end_address])
    @mpg=params[:mpg]
    @trip = Trip.new(params[:name])
    @trip.start = start_place
    @trip.finish = end_place
    @trip.get_distance_duration(start_place.address, end_place.address)
    # @trip.get_gas_price(start_place.latitude.to_s, start_place.longitude.to_s)
    # @min= @trip.gas_prices.min
    @trip.get_gas_stations


   
    # @trips=[]

    # @trips<<@trip
   
    # @hash = Gmaps4rails.build_markers(@trips) do |trip, marker|
    #   marker.lat trip.start.latitude
    #   marker.lng trip.start.longitude

    #   marker.lat trip.finish.latitude
    #   marker.lng trip.finish.longitude


    # end
    




   end 


end