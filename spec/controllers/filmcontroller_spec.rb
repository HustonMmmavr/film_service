require 'rails_helper'

RSpec.describe FilmController, :type => :controller do
  before :context do
    film = Film.new(:title => "Test", :about => "About", :year => 111, :length => 12, :rating => "1.2", :director => "Directo")
    film.valid?
    p film.errors
    film.save()
    film.valid?
    p film.errors
    film = Film.find_by_title("Test")
    @id = film.id
    @title = film.title
  end

  context "check controller" do
    it "checks get film (by id) which dosent exist" do
      get :get_film, params: {'id' => 100} #params#6 #{:id => 6}

      data = JSON.parse(response.body)
      expect(response.status).to eq(404)
      expect(data['respMsg']).to eq("No such film")
    end

    it "checks get film invalid id" do
      get :get_film, params: {'id' => 'fsd'} #params#6 #{:id => 6}

      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("id is invalid")
    end

    it "checks get user (by id) ok" do
      get :get_film, params: {'id' => @id} #params#6 #{:id => 6}

      data = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(data['respMsg']).to eq("Ok")
      expect(data['film']['filmId']).to eq(@id)
      expect(data['film']['filmTitle']).to eq(@title)
    end

    it "checks get_films_count" do
      get :get_films_count

      data = JSON.parse(response.body)
      expect(response.status).to eq(200)
    end
###########################################################################
    it "checks delete film which not exist" do
      delete :delete_film, :params => {:filmId => 100}
      data = JSON.parse(response.body)
      expect(response.status).to eq(404)
      expect(data['respMsg']).to eq("No such film")
    end

    it "checks delete film incorrect id" do
      delete :delete_film, :params => {:filmId => "esgr"}
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("filmId is invalid")
    end

    it "checks delete film ok" do
      delete :delete_film, :params => {:filmId => @id}
      data = JSON.parse(response.body)
      expect(response.status).to eq(200)
    end

#########################################################################
    it "check update film which not exist" do
      post :update_film, :params => {:filmId => 100, :filmTitle => "Title", :filmAbout => "About",
              :filmYear => "111", :filmRating => "7", :filmDirector => "Directo"}
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(404)
      expect(data['respMsg']).to eq("No film to update")
    end

    it "check update film incorrect id" do
      post :update_film, :params => {:filmId => 100, :filmTitle => "Title", :filmAbout => "About",
              :filmYear => "111", :filmRating => "7", :filmDirector => "Directo"}
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(404)
      expect(data['respMsg']).to eq("No film to update")
    end

    it "check update film incorrect year" do
      post :update_film, :params => {:filmId => 100, :filmTitle => "Title", :filmAbout => "About",
              :filmYear => "srg", :filmRating => "7", :filmDirector => "Directo"}
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("filmYear is invalid")
    end

    it "check update film incorrect rating" do
      post :update_film, :params => {:filmId => 100, :filmTitle => "Title", :filmAbout => "About",
              :filmYear => "111", :filmRating => "srg", :filmDirector => "Directo"}
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("filmRating is invalid")
    end

    it "check update film incorrect length" do
      post :update_film, :params => {:filmId => 100, :filmTitle => "Title", :filmAbout => "About",
              :filmLength => "sgd", :filmRating => "7", :filmDirector => "Directo", }
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("filmLength is invalid")
    end

    it "check update film incorrect length" do
      post :update_film, :params => {:filmId => @id, :filmTitle => "Title", :filmAbout => "About",
              :filmLength => "111", :filmRating => "7", :filmDirector => "Directo", }
      # post :update_film, :params
      expect(response.status).to eq(200)
    end
#######################################################################

    it "checks get_films incorrect limit" do
      get :get_films, :params => {:limit=> 'sf', :offset=>100}
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("limit is invalid")
    end

    it "checks get films incorrect offset" do
      get :get_films, :params => {:limit=> 100, :offset=>'gsdg'}
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("offset is invalid")
    end

    it "checks get films ok" do
      get :get_films, :params => {:limit=> 100, :offset=>0}

      data = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(data['respMsg']).to eq("Ok")
    end

###################################################################
    it "check create film empty title" do
      post :create_film, :params => {:filmAbout => "About",
              :filmLength => "", :filmDirector => "Directo", }
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("filmTitle is Empty")
    end

    it "check create film empty about" do
      post :create_film, :params => {:filmTitle => "Title",
              :filmLength => "sgd", :filmDirector => "Directo", }
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("filmAbout is Empty")
    end

    it "check create film empty year" do
      post :create_film, :params => {:filmTitle => "Title", :filmAbout => "About",
              :filmLength => "1", :filmDirector => "Directo", }
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("filmYear is Empty")
    end

    it "check create film incorrect year" do
      post :create_film, :params => {:filmTitle => "Title", :filmAbout => "About",
              :filmLength => "1", :filmYear => "7aewf", :filmDirector => "Directo", }
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
        expect(data['respMsg']).to eq("filmYear is invalid")
    end

    it "check create film empty lenght" do
      post :create_film, :params => { :filmTitle => "Title", :filmAbout => "About",
            :filmYear => '4', :filmDirector => "Directo", }
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("filmLength is Empty")
    end

    it "check create film incorrect lenght" do
      post :create_film, :params => { :filmTitle => "Title", :filmAbout => "About",
              :filmLength => "sgd", :filmYear => "7", :filmDirector => "Directo", }
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("filmLength is invalid")
    end

    it "check create film empty director" do
      post :create_film, :params => { :filmTitle => "Title", :filmAbout => "About",
              :filmLength => "12", :filmYear => "7", }
      # post :update_film, :params
      data = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(data['respMsg']).to eq("filmDirector is Empty")
    end

    it "check create ok" do
      post :create_film, :params => { :filmTitle => "Title", :filmAbout => "About",
              :filmLength => "1", :filmYear => "7", :filmDirector => "Directo", }
      data = JSON.parse(response.body)
      expect(response.status).to eq(201)
      expect(data['respMsg']).to eq("Ok")
    end
  end

  context "checks status" do
    it "check" do
      get :status
      expect(response.status).to eq(200)
    end
  end
end
