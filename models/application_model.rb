class ApplicationModel
  
  def self.from_json(json)
    json[json_key].map do |instance_json|
      puts "Instance JSON is #{instance_json}"
      self.new(instance_json)
    end
  end

  protected
  
  def self.json_key
    raise NotImplementedError
  end

end