require_relative "../../models/playlist.rb"
require 'json'

describe Playlist do
  context "during playlist creation" do
    let(:input) { {"id" => 1, "user_id" => "2", "song_ids" => [15, 64, 2]} }
    let(:playlist) { Playlist.new(input) }
    
    it "should take the id from input json" do
      expect(playlist.id).to eq(input["id"])
    end
    
    it "should take the user_id from input json" do
      expect(playlist.user_id).to eq(input["user_id"])
    end

    it "should take the song_ids from input json" do
      expect(playlist.song_ids).to eq(input["song_ids"])
    end
    
    context "with unwhitelisted fields" do
      let(:input) { {"id" => 1, "user_id" => "2", "song_ids" => [15, 64, 2], "rating" => 5} }
      
      it "shouldn't take other fields from input json" do
        expect{playlist.rating}.to raise_error(NoMethodError)
      end
    end
  end

  context "when generating json" do
    let(:input) { {"id" => 1, "user_id" => "2", "song_ids" => [15, 64, 2]} }
    let(:playlist) { Playlist.new(input) }

    it "should match the expected output" do
      expect(playlist.to_json).to eq("{\"id\":1,\"user_id\":\"2\",\"song_ids\":[15,64,2]}")
    end
  end
  
  context "adding a song" do
    let(:input) { {"id" => 1, "user_id" => "2", "song_ids" => [15, 64, 2]} }
    let(:playlist) { Playlist.new(input) }
    
    it "should add a song id to its list of song ids" do
      playlist.add_song(500)
      
      expect(playlist.song_ids).to eq([15, 64, 2, 500])
    end
    
    it "should not add a song id to its list of song ids if the id already exists" do
      playlist.add_song(15)

      expect(playlist.song_ids).to eq([15, 64, 2])
    end
  end
end