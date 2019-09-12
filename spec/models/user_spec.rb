require_relative "../../models/user.rb"
require 'json'

describe User do
  context "during user creation" do
    let(:input_json) { {id: 1, name: "Bob Ross"}.to_json }
    let(:user) { User.new(input_json) }
    
    it "should take the id from input json" do
      expect(user.id).to eq(input_json["id"])
    end
    
    it "should take the name from input json" do
      expect(user.name).to eq(input_json["name"])
    end
  end
end