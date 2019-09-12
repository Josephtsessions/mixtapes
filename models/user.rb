require_relative './application_model'

class User < ApplicationModel
  
  attr_reader :id, :name

  def initialize(attributes)
    @id = attributes["id"]
    @name = attributes["name"]
  end

  def to_json(options = {})
    {id: id, name: name}.to_json
  end
  
  protected
  
  def self.json_key
    "users"
  end
  
end