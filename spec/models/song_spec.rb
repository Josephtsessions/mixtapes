require_relative "../../models/song.rb"
require 'json'

describe Song do
  context "during song creation" do
    let(:input_json) { {id: 1, title: "The Perfect Product", artist: "Tupperware Remix Party"}.to_json }
    let(:song) { Song.new(input_json) }
    
    it "should take the id from input json" do
      expect(song.id).to eq(input_json["id"])
    end
    
    it "should take the title from input json" do
      expect(song.title).to eq(input_json["title"])
    end

    it "should take the artist from input json" do
      expect(song.artist).to eq(input_json["artist"])
    end

    context "with unwhitelisted fields" do
      let(:input_json) { {id: 1, title: "The Perfect Product", artist: "Tupperware Remix Party", rating: 5}.to_json }

      it "shouldn't take other fields from input json" do
        expect{song.rating}.to raise_error(NoMethodError)
      end
    end
  end
end