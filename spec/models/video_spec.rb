require 'spec_helper'

describe Video do
  context 'relations' do
    it { should belong_to(:category) }
    it { should have_many(:reviews).order('created_at DESC') }
    it { should have_many(:queue_items) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:video_url) }
  end

  describe ".search_by_title" do
    before(:each) do
      Fabricate(:video, title: 'Video one', description: 'Video one is awesome', created_at: 1.day.ago)
      Fabricate(:video, title: 'Video two', description: 'Video two is awesome')
      Fabricate(:video, title: 'Family Guy', description: 'Family Guy by Seth McFarland')
    end

    it 'returns an empty array when there is no match' do
      videos = Video.search_by_title('unknown title')

      expect(videos.empty?).to be true
    end

    it 'returns an array with a single Video when there is an exact match' do
      videos = Video.search_by_title('Family Guy')

      expect(videos.first.title).to eq('Family Guy')
    end

    it 'returns an array with a single Video when there is a partial match' do
      videos = Video.search_by_title('Guy')

      expect(videos.first.title).to eq('Family Guy')
    end

    it 'returns an array with two Videos ordered by created_at' do
      videos = Video.search_by_title('Video')

      expect(videos.map(&:title)).to eq(['Video two', 'Video one'])
    end

    it 'returns an empty array when there is an empty search term' do
      videos = Video.search_by_title('')

      expect(videos).to eq([])
    end
  end

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end

    context "with title, description and reviews" do
      it 'returns an an empty array for no match with reviews option' do
        star_wars = Fabricate(:video, title: "Star Wars")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, text: "such a star movie!")
        refresh_index

        expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
      end

      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "the sun is a star!")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, text: "such a star movie!")
        refresh_index

        expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end

    context "filter with average ratings" do
      let(:star_wars_1) { Fabricate(:video, title: "Star Wars 1") }
      let(:star_wars_2) { Fabricate(:video, title: "Star Wars 2") }
      let(:star_wars_3) { Fabricate(:video, title: "Star Wars 3") }

      before do
        Fabricate(:review, rating: "2", video: star_wars_1)
        Fabricate(:review, rating: "4", video: star_wars_1)
        Fabricate(:review, rating: "4", video: star_wars_2)
        Fabricate(:review, rating: "2", video: star_wars_3)
        refresh_index
      end

      context "with only rating_from" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "4.1").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "4.0").records.to_a).to eq [star_wars_2]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "3.0").records.to_a).to match_array [star_wars_2, star_wars_1]
        end
      end

      context "with only rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_to: "1.5").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_to: "2.5").records.to_a).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_to: "3.4").records.to_a).to match_array [star_wars_1, star_wars_3]
        end
      end

      context "with both rating_from and rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "3.4", rating_to: "3.9").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "1.8", rating_to: "2.2").records.to_a).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "2.9", rating_to: "4.1").records.to_a).to match_array [star_wars_1, star_wars_2]
        end
      end
    end
  end

  describe "#average_rating" do
    let(:video) do
      Fabricate(:video, title: 'Video one', description: 'Video one is awesome')
    end

    it 'returns 0 when there are no comments' do
      expect(video.average_rating).to eq 0
    end

    it 'returns the rating of the comment when there is one comment' do
      Fabricate(:review, rating: 3, video: video)

      expect(video.average_rating).to eq 3.0
    end
    it 'returns the average rating of 3 comments' do
      Fabricate(:review, rating: 1, video: video)
      Fabricate(:review, rating: 2, video: video)
      Fabricate(:review, rating: 5, video: video)

      expect(video.average_rating).to eq 2.7
    end
  end
end
