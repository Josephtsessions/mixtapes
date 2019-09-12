require_relative './application_model'

class User < ApplicationModel
  
  attr_reader :id, :name

  def initialize(json)
    @id = json["id"]
    @name = json["name"]
  end
  
  protected
  
  def self.json_key
    "users"
  end
  
end