class FilmController < ApplicationController
  def is_parameter_valid(param_name, param, regexp = nil)
    if param == nil || param == ""
        return param_name + " is Empty"
    end
    if regexp
        if !regexp.match? param
            return param_name + " is invalid"
        end
    end
    true
  end

  def init_params()
    @important_params = ['filmTitle', 'filmAbout', 'filmLength', 'filmYear', 'filmDirector']
    @all_params = ['filmTitle', 'filmAbout', 'filmLength', 'filmYear', 'filmDirector',
                  'filmImage', 'filmRating']
  end

  def create_film()
    init_params
    @important_params.each do |key|
      if key == 'filmLength' || key = 'filmYear'
        check = is_parameter_valid key, param[key], @int_regexp
      else
        check = is_parameter_valid key, param_key, nil
      end
      if check != true
        return render :json => {:respMsg => check}, :status => 400
      end
    end

    film = Film.new()
    if film.valid?
    begin
      film.save()
      responseMessage = ResponseMessage.new("Ok")
      return render :json => {:respMsg => "Ok"}, :status => 201
    rescue
        responseMessage = ResponseMessage.new("Database error")
        return render :json => responseMessage, :status => 500
    end
  end

  def status()
    render :json => {:respMsg => "alive"}, status: 200
  end

  #return one film
  def get_film()
    id = params[:id]
    check_film_id = is_parameter_valid 'id', id, @int_regexp
    if check_film_id != true
        return render :json => {:respMsg => check_film_id}, :status => 400
    end

    begin
        @film = Film.find_by_id(id)
        if @film == nil
            responseMessage = ResponseMessage.new("No such film")
            return render :json => responseMessage, :status => 404
        end
    rescue
        responseMessage = ResponseMessage.new("Database error")
        return render :json => responseMessage, :status => 500
    end
    #not this render
    film = fill_film
    render :json => {'respMsg': 'Ok', 'film': film}
    #render :json => @film#, :only => ['id', "avatar"]
  end

  #return json arr
  def get_films()
    id = params[:id]
  end

  def delete_film()
    id = params[:id]
    check_film_id = is_parameter_valid 'id', id, @int_regexp
    if check_film_id != true
        return render :json => {:respMsg => check_film_id}, :status => 400
    end
  end

  def update_film()
    init_params
    update_fields = []
    @all_params.each do |key|
      key = 
    end
  end
end
