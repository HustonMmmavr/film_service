require 'rails_helper'

#TODO check length
RSpec.describe Film, :type => :model do
  before :context do
    film = Film.new(:title => "Title", :about => "About", :year => "111", :rating => "1.2", :director => "Directo")
    film.save
  end

  context "check film" do
    it "is not valid with not valid attributes" do
      expect(Film.new).to_not be_valid
    end

    it "is not valid without title" do
      film = Film.new(:about => "About", :year => "111", :rating => "1.2", :director => "Directo")
      expect(film).to_not be_valid
      expect(film.errors.messages[:title][0]).to eq("Title can't be empty.")
    end

    it "is not valid without about" do
      film = Film.new(:title => "Title", :year => "111", :rating => "1.2", :director => "Directo")
      expect(film).to_not be_valid
      expect(film.errors.messages[:about]).to eq(["About can't be empty."])
    end

    it "is not valid without year" do
      film = Film.new(:title => "Title", :about => "About",:rating => "1.2", :director => "Directo")
      expect(film).to_not be_valid
      expect(film.errors.messages[:year][0]).to eq("Year can't be empty.") #, ["is invalid."])
    end

    it "is not valid with incorrect year" do
      film = Film.new(:title => "Title", :about => "About", :year => "sgrsdg", :rating => "1.2", :director => "Directo")
      expect(film).to_not be_valid
      expect(film.errors.messages[:year]).to eq(["is not a number"])
    end

    it "is not valid without rating" do
      film = Film.new(:title => "Title", :about => "About", :year => "1", :director => "Directo")
      expect(film).to_not be_valid
      expect(film.errors.messages[:rating][0]).to eq("Rating can't be empty.")
    end

    it "is not valid with incorrect rating" do
      film = Film.new(:title => "Title", :about => "About", :year => "1", :rating => "1.2fsd", :director => "Directo")
      expect(film).to_not be_valid
      expect(film.errors.messages[:rating]).to eq(["is not a number"])
    end

    it "is not valid without director" do
      film = Film.new(:title => "Title", :about => "About", :year => "1", :rating => "1.2fsd")
      expect(film).to_not be_valid
      expect(film.errors.messages[:director]).to eq(["Director can't be empty."])
    end

    it "valid" do
      film = Film.new(:title => "Title", :about => "About", :year => "1", :rating => "1.2", :director => 'fs')
      expect(film).to be_valid
    end
  end
end
