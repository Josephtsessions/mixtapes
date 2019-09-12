#!/usr/bin/env ruby

require 'json'
require_relative './models/playlist'
require_relative './models/song'
require_relative './models/user'

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

begin
  input = File.read(INPUT_FILENAME)
  
  input_json = JSON.parse(input)
  
  playlists = Playlist.from_json(input_json)
  songs = Song.from_json(input_json)
  users = User.from_json(input_json)
rescue JSON::ParserError => e
   puts "#{INPUT_FILENAME} doesn't appear to be properly formatted JSON." 
   raise e
end

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
          playlist.add(song)
        end
      when CREATE_PLAYLIST
        
      when REMOVE_PLAYLIST
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