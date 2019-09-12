#!/usr/bin/env ruby

require 'json'
require_relative './models/playlist'
require_relative './models/song'
require_relative './models/user'

if ARGV.length != 3
  puts "Usage: main.rb [input_path.json] [changes_path.json] [output_path.json]"
  exit 1
end

begin
  input_filename = ARGV[0]
  
  input = File.read(input_filename)
  
  input_json = JSON.parse(input)
  
  playlists = Playlist.from_json(input_json)
  
  print playlists
rescue JSON::ParserError => e
   puts "#{input_filename} doesn't appear to be properly formatted JSON." 
   raise e
end

