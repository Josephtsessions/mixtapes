require_relative './application_model'

class Song < ApplicationModel
  
  attr_reader :id, :artist, :title

  def initialize(attributes)
    @id = attributes["id"]
    @artist = attributes["artist"]
    @title = attributes["title"]
  end

  def to_json(options = {})
    {id: id, artist: artist, title: title}.to_json
  end
  
  protected
  
  def self.json_key
    "songs"
  end
  
end