require_relative "../../models/user.rb"
require 'json'

describe User do
  context "during user creation" do
    let(:input) { {"id" => 1, "name" => "Bob Ross"} }
    let(:user) { User.new(input) }
    
    it "should take the id from input json" do
      expect(user.id).to eq(input["id"])
    end
    
    it "should take the name from input json" do
      expect(user.name).to eq(input["name"])
    end

    context "with unwhitelisted fields" do
      let(:input) { {"id" => 1, "name" => "Bob Ross", "rating" => 5, "style" => 'majestic'} }

      it "shouldn't take other fields from input json" do
        expect{user.style}.to raise_error(NoMethodError)
      end
    end
  end

  context "when generating json" do
    let(:input) { {"id" => 1, "name" => "Bob Ross"} }
    let(:user) { User.new(input) }

    it "should match the expected output" do
      expect(user.to_json).to eq({:id=>1, :name=>"Bob Ross"})
    end
  end
end