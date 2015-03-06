class TripsController < ApplicationController
  
  def new

  end
 
  def show
  	#get parameters from form for a Trip
    start_place = Place.new(params[:start_address])
    end_place = Place.new(params[:end_address])
    
   
    #create Trip object
    @trip = Trip.new(params[:name], start_place, end_place, params[:mpg])
    
    #call Trip methods
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