class ApplicationModel
  
  def self.from_json(json)
    json[json_key].map do |instance_json|
      self.new(instance_json)
    end
  end

  protected
  
  def to_json(options = {})
    raise NotImplementedError
  end
  
  def self.json_key
    raise NotImplementedError
  end

end