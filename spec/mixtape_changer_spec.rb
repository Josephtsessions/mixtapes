require_relative "../mixtape_changer.rb"

describe MixtapeChanger do
  let(:mixtape_changer) { MixtapeChanger.new(changes_json) }
  let(:changed_playlists) { mixtape_changer.playlists_with_changes(playlists: playlists, users: users, songs: songs) }

  context "adding a song to a playlist" do
    let(:changes_json) { %Q{{\"changes\":[{\"type\":\"add song\",\"playlist_id\":\"1\",\"song_id\":\"150\"}]}} }
    let(:playlists) { [Playlist.new("id" => "1", "user_id" => "1", "song_ids" => ["1"])] }
    let(:users) { [User.new("id" => "15", "name" => 'Robert Smith')] }

    # Could it be?? RICK ROLLED IN A TEST?!
    let(:songs) { [Song.new("id" => "150", "title" => 'Never Gonna Give You Up', "artist" => 'Rick Astley')] }
    
    it 'should add the song if the song exists' do
      expect(changed_playlists.count).to eq(playlists.count)
      expect(changed_playlists.first.song_ids).to eq(["1", "150"])
    end
    
    it 'should not print an error if the song exists' do
      expect { changed_playlists.first.song_ids }.to_not output(/Couldn't find song with id ##{songs.first.id}/).to_stdout
    end
    
    describe "without matching songs" do
      let(:songs) { [] }

      it 'should print an error if the song does not exist' do
        expect { changed_playlists.first.song_ids }.to output(/Couldn't find song with id #150/).to_stdout
      end
    end
  end
  
  context "removing a playlist" do
    let(:changes_json) { %Q{{\"changes\":[{\"type\":\"remove playlist\",\"playlist_id\":\"1\"}]}} }
    let(:playlists) { [Playlist.new("id" => "1", "user_id" => "1", "song_ids" => ["1"])] }
    let(:songs) { [Song.new("id" => "1", "title" => 'Lone Digger', "artist" => 'Caravan Palace')] }
    let(:users) { [User.new("id" => "1", "name" => 'Robert Smith')] }

    it 'should remove the playlist if it exists' do
      expect(changed_playlists.count).to eq(0)
    end
    
    it 'should not print an error if the playlist exists' do
      expect { changed_playlists }.to_not output(/Couldn't find playlist ##{playlists.first.id}/).to_stdout
    end
    
    describe 'without a matching playlist' do
      let(:playlists) { [Playlist.new("id" => "180", "user_id" => "1", "song_ids" => ["1"])] }
      
      it 'should print an error' do
        expect { changed_playlists.first.song_ids }.to output(/Couldn't find playlist/).to_stdout
      end
    end
  end
  
  context "creating a playlist" do
    let(:changes_json) { %Q{{\"changes\":[{\"type\":\"create playlist\",\"user_id\":\"1\",\"song_ids\":[\"1\"]}]}} }
    let(:playlists) { [Playlist.new("id" => "1", "user_id" => "1", "song_ids" => ["1"])] }
    let(:songs) { [Song.new("id" => "1", "title" => 'Lone Digger', "artist" => 'Caravan Palace')] }
    let(:users) { [User.new("id" => "1", "name" => 'Robert Smith')] }

    context "with the happy path" do
      it "should create the playlist" do
        expect(changed_playlists.count).to eq(playlists.count + 1)
        
        new_playlist = changed_playlists.detect {|playlist| playlist.id == "2"}
        expect(new_playlist.nil?).to be(false)

        expect(new_playlist.user_id).to eq("1")
        expect(new_playlist.song_ids).to eq(["1"])
      end
    end
    
    context "with an invalid user" do
      let(:users) { [User.new("id" => "122", "name" => 'Robert Smith')] }

      it "should not create the playlist" do
        expect(changed_playlists.count).to eq(playlists.count)

        expect(changed_playlists.first.id).to eq(playlists.first.id)
      end
      
      it "should print an error" do
        expect { changed_playlists }.to output(/Couldn't find user/).to_stdout
      end
    end
    
    context "with an invalid song" do
      let(:songs) { [Song.new("id" => "227", "title" => 'Lone Digger', "artist" => 'Caravan Palace')] }

      it "should not create the playlist" do
        expect(changed_playlists.count).to eq(playlists.count)

        expect(changed_playlists.first.id).to eq(playlists.first.id)
      end
      
      it "should print an error" do
        expect { changed_playlists }.to output(/Couldn't find song/).to_stdout
      end
    end
  end
  
end