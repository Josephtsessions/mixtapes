require_relative "../../models/playlist.rb"
require 'json'

describe Playlist do
  context "during playlist creation" do
    let(:input_json) { {id: 1, user_id: "2", song_ids: [15, 64, 2]}.to_json }
    let(:playlist) { Playlist.new(input_json) }
    
    it "should take the id from input json" do
      expect(playlist.id).to eq(input_json["id"])
    end
    
    it "should take the user_id from input json" do
      expect(playlist.user_id).to eq(input_json["user_id"])
    end

    it "should take the song_ids from input json" do
      expect(playlist.song_ids).to eq(input_json["song_ids"])
    end
  end
end