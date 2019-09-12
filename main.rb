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
   puts "#{input_filename} doesn't appear to be properly formatted JSON." 
   raise e
end

output_json = {
    users: users.map(&:to_json),
    playlists: playlists.map(&:to_json),
    songs: songs.map(&:to_json)
}.to_json

File.write(OUTPUT_FILENAME, output_json)