class MixtapeParser
  
  def initialize(mixtape_filename)
    @filename = mixtape_filename
  end
  
  def json
    @json ||= begin
      input = File.read(@filename)
      
      JSON.parse(input)
    rescue StandardError => e
      puts "Couldn't read #{@filename}:"
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