#!/usr/bin/env ruby

require 'json'
require_relative './models/playlist'
require_relative './models/song'
require_relative './models/user'

require_relative './mixtape_parser'
require_relative './mixtape_changer'

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

input_json = File.read(INPUT_FILENAME)
parser = MixtapeParser.new(input_json)

playlists = parser.playlists
songs = parser.songs
users = parser.users

changes_json = File.read(CHANGES_FILENAME)
changer = MixtapeChanger.new(changes_json)
models = {
  playlists: playlists,
  users: users,
  songs: songs   
}

changed_playlists = changer.playlists_with_changes(models)

output_json = {
    users: users.map(&:to_json),
    playlists: changed_playlists.map(&:to_json),
    songs: songs.map(&:to_json)
}.to_json

File.write(OUTPUT_FILENAME, output_json)