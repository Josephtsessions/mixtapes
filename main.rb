#!/usr/bin/env ruby

require 'json'
require_relative './models/playlist'
require_relative './models/song'
require_relative './models/user'

require_relative './mixtape_parser'

if ARGV.length != 3
  puts "Usage: main.rb [input_path.json] [changes_path.json] [output_path.json]"
  exit 1
end

INPUT_FILENAME = ARGV[0]
CHANGES_FILENAME = ARGV[1]
OUTPUT_FILENAME = ARGV[2]

ADD_SONG = "add song"
CREATE_PLAYLIST = "create playlist"
REMOVE_PLAYLIST = "remove playlist"

# We should check for an existing file before blindly writing to it so bad things don't happen!
if File.exist?(OUTPUT_FILENAME)
  puts "#{OUTPUT_FILENAME} already exists. Please specify a new filename or move the file so you don't lose data!"
  exit 1
end

parser = MixtapeParser.new(INPUT_FILENAME)

playlists = parser.playlists
songs = parser.songs
users = parser.users

begin
  changes_file = File.read(CHANGES_FILENAME)
  
  changes = JSON.parse(changes_file).fetch("changes", [])
  
  changes.each do |change|
    errors = []
    
    case change["type"]
    when ADD_SONG
      playlist_id = change["playlist_id"]
      song_id = change["song_id"]
      
      playlist = playlists.detect {|playlist| playlist.id == playlist_id}
      song = songs.detect {|song| song.id == song_id}
      
      errors.push("Couldn't find song with id #{song_id}") if song.nil?
      errors.push("Couldn't find playlist with id #{playlist_id}") if playlist.nil?
      
      if errors.empty?
        playlist.add_song(song.id)
      end
    when CREATE_PLAYLIST
      song_ids = change["song_ids"]
      user_id = change["user_id"]
      
      song_ids.each do |song_id|
        song = songs.detect {|song| song.id == song_id}

        errors.push("Couldn't find song ##{song_id}") if song.nil?
      end

      user = users.detect {|user| user.id == user_id}
      
      if errors.empty?
        last_playlist_id = playlists.map(&:id).sort&.max || 0
        new_playlist = Playlist.new(id: last_playlist_id.to_i + 1, user_id: user_id, song_ids: song_ids)
        playlists.push()
      end
    when REMOVE_PLAYLIST
      playlist_id = change["playlist_id"]
      
      playlist_index = playlists.find_index {|playlist| playlist.id == playlist_id}
      
      errors.push("Couldn't find playlist ##{playlist.id}") if playlist_index.nil?
      
      if errors.empty?
        playlists.delete_at(playlist_index)
      end
    end
    
    # I chose to skip here - I'd rather skip a bad row than fail the whole operation for the user. Skipping doesn't
    # make sense for every business problem but it does for this one and I think it's more gracious this way.
    if !errors.empty?
      puts "Skipping #{change}:"
      errors.each {|error| puts "    #{error}"}
    end
  end
rescue JSON::ParserError => e
  puts "#{CHANGES_FILENAME} doesn't appear to be properly formatted JSON."
  raise e
end

output_json = {
    users: users.map(&:to_json),
    playlists: playlists.map(&:to_json),
    songs: songs.map(&:to_json)
}.to_json

File.write(OUTPUT_FILENAME, output_json)