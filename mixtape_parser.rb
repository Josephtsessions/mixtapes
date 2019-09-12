class MixtapeParser
  
  def initialize(input_json)
    @input_json = input_json
  end
  
  def json
    @json ||= begin
      JSON.parse(@input_json)
    rescue StandardError => e
      puts "Couldn't parse input json:"
      raise e
    end
  end
 
  def playlists
    Playlist.from_json(json)
  end
  
  def songs
    Song.from_json(json)
  end
  
  def users
    User.from_json(json)
  end
    
end