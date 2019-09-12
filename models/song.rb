require_relative './application_model'

class Song < ApplicationModel
  
  attr_reader :id, :artist, :title

  def initialize(json)
    @id = json["id"]
    @artist = json["artist"]
    @title = json["title"]
  end

  def to_json(options = {})
    {id: id, artist: artist, title: title}
  end
  
  protected
  
  def self.json_key
    "songs"
  end
  
end