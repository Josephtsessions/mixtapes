require_relative './application_model'

class Playlist < ApplicationModel
  
  attr_reader :id, :user_id, :song_ids
  
  def initialize(json)
    @id = json["id"]
    @user_id = json["user_id"]
    @song_ids = json["song_ids"]
  end
  
  # In a nontrivial system, I'd use an existing gem like AMS for serialization to split that responsibility out into its own set of files.
  # We could test them independently, reuse them elsewhere and simplify our models. 
  # But for our purposes, it's simpler to just do 'em here.
  def to_json(options = {})
    {id: id, user_id: user_id, song_ids: song_ids}
  end
  
  protected
  
  # I could have opted to use a gem to pluralize these names automatically. Rails has this stuff built in,
  # but I chose to keep it simple for us for now.
  def self.json_key
    "playlists"
  end
  
end