require_relative "../mixtape_parser.rb"

describe MixtapeParser do
  
  describe "reading a json file" do
    let(:mixtape_parser) { MixtapeParser.new(json) }
    let(:json) { File.read("spec/mixtape.json") }
    
    it "returns the correct users" do
      user = mixtape_parser.users.detect {|user| user.id == "1"}
      
      expect(user.name).to eq("Albin Jaye")
    end

    it "returns the correct playlists" do
      playlist = mixtape_parser.playlists.detect {|playlist| playlist.id == "1"}

      expect(playlist.song_ids).to eq(["1"])
      expect(playlist.user_id).to eq("1")
    end

    it "returns the correct songs" do
      song = mixtape_parser.songs.detect {|song| song.id == "1"}

      expect(song.title).to eq("Never Be the Same")
      expect(song.artist).to eq("Camila Cabello")
    end
  end
  
end