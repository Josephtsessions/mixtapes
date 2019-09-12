require_relative './application_model'

class Song < ApplicationModel

  def initialize(json)
    @id = json["id"]
    @artist = json["artist"]
    @title = json["title"]
  end
  
  protected
  
  def self.json_key
    "songs"
  end
  
end