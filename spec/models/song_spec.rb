require_relative "../../models/song.rb"
require 'json'

describe Song do
  context "during song creation" do
    let(:input) { {"id" => 1, "title" => "The Perfect Product", "artist" => "Tupperware Remix Party"} }
    let(:song) { Song.new(input) }
    
    it "should take the id from input json" do
      expect(song.id).to eq(input["id"])
    end
    
    it "should take the title from input json" do
      expect(song.title).to eq(input["title"])
    end

    it "should take the artist from input json" do
      expect(song.artist).to eq(input["artist"])
    end

    context "with unwhitelisted fields" do
      let(:input) { {"id" => 1, "title" => "The Perfect Product", "artist" => "Tupperware Remix Party", "rating" => 5} }

      it "shouldn't take other fields from input json" do
        expect{song.rating}.to raise_error(NoMethodError)
      end
    end
  end
  
  context "when generating json" do
    let(:input) { {"id" => 1, "title" => "The Perfect Product", "artist" => "Tupperware Remix Party"} }
    let(:song) { Song.new(input) }

    it "should match the expected output" do
      expect(song.to_json).to eq({:artist=>"Tupperware Remix Party", :id=>1, :title=>"The Perfect Product"})
    end
  end
end