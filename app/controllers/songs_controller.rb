require 'rack-flash'

class SongsController < ApplicationController
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  get '/songs/new' do
    erb :'/songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'/songs/show'
  end

  post '/songs' do
    @song = Song.find_or_create_by(:name => params["Name"])
    @song.artist = Artist.find_or_create_by(:name => params["Artist Name"])
    # params["genres"].each { |g| @song.genres << Genre.find_or_create_by(:name => g)}
    @song.genre_ids = params[:genres]
    @song.save

    flash[:message] = "Successfully created song."
    redirect to "/songs/#{@song.slug}"
  end

  get '/songs/:slug/edit' do
   @song = Song.find_by_slug(params[:slug])

   erb :'/songs/edit'
 end

 patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @song.update(params[:song])
    @song.artist = Artist.find_or_create_by(name: params[:artist][:name])
    @song.save

    erb :"/songs/#{@song.slug}"
  end

end
