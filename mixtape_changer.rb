class MixtapeChanger

  ADD_SONG = "add song"
  CREATE_PLAYLIST = "create playlist"
  REMOVE_PLAYLIST = "remove playlist"

  def initialize(changes_json)
    @changes_json = changes_json
  end
  
  def playlists_with_changes(playlists:, users:, songs:)
    playlists = playlists.clone
    users = users.clone
    songs = songs.clone
    
    changes.each do |change|
      case change["type"]
        when ADD_SONG
          add_song(
            change: change, 
            playlists: playlists, 
            songs: songs
          ).then { |errors| print_errors(errors, change: change) }
          
        when CREATE_PLAYLIST
          create_playlist(
            change: change,
            playlists: playlists,
            songs: songs,
            users: users
          ).then { |errors| print_errors(errors, change: change) }

        when REMOVE_PLAYLIST
          remove_playlist(
            change: change,
            playlists: playlists
          ).then { |errors| print_errors(errors, change: change) }
          
      end
    end
    
    playlists
  end
  
  private
  
  def changes
    @changes ||= begin
      JSON.parse(@changes_json).fetch("changes", [])
    rescue StandardError => e
      puts "Error parsing changes json:"
      raise e
    end
  end
  
  def add_song(change:, playlists:, songs:)
    errors = []
    
    playlist_id = change["playlist_id"]
    song_id = change["song_id"]

    playlist = playlists.detect {|playlist| playlist.id == playlist_id}
    song = songs.detect {|song| song.id == song_id}

    errors.push("Couldn't find song with id ##{song_id}") if song.nil?
    errors.push("Couldn't find playlist with id ##{playlist_id}") if playlist.nil?

    if errors.empty?
      playlist.add_song(song.id)
    end
    
    errors
  end
  
  def create_playlist(change:, playlists:, songs:, users:)
    errors = []
    
    song_ids = change["song_ids"]
    user_id = change["user_id"]

    song_ids.each do |song_id|
      song = songs.detect {|song| song.id == song_id}

      errors.push("Couldn't find song ##{song_id}") if song.nil?
    end

    user = users.detect {|user| user.id == user_id}
    errors.push("Couldn't find user ##{user_id}") if user.nil?

    if errors.empty?
      last_playlist_id = playlists.map(&:id).sort&.max || 0
      new_playlist = Playlist.new("id" => last_playlist_id.to_i + 1, "user_id" => user_id, "song_ids" => song_ids)
      playlists.push(new_playlist)
    end
    
    errors
  end
  
  def remove_playlist(change:, playlists:)
    errors = []
    
    playlist_id = change["playlist_id"]

    playlist_index = playlists.find_index {|playlist| playlist.id == playlist_id}

    errors.push("Couldn't find playlist ##{playlist_id}") if playlist_index.nil?

    if errors.empty?
      playlists.delete_at(playlist_index)
    end
    
    errors
  end
  
  def print_errors(errors, change:)
    return if errors.empty?
    
    # I chose to skip here - I'd rather skip a bad row than fail the whole operation for the user. Skipping doesn't
    # make sense for every business problem but it does for this one and I think it's more gracious this way.
    puts "Skipping #{change}:"
    errors.each {|error| puts "    #{error}"}
  end
    
end