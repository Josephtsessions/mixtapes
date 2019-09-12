require_relative './application_model'

class Playlist < ApplicationModel
  
  def initialize(json)
    @id = json["id"]
    @user_id = json["user_id"]
    @song_ids = json["song_ids"]
  end
  
  protected
  
  # I could have opted to use a gem to pluralize these names automatically. Rails has this stuff built in,
  # but I chose to keep it simple for us for now.
  def self.json_key
    "playlists"
  end
  
end