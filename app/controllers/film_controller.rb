class FilmController < ApplicationController
  @@important_params = ['filmTitle', 'filmAbout', 'filmLength', 'filmYear', 'filmDirector']
  @@all_params = ['filmTitle', 'filmAbout', 'filmLength', 'filmYear', 'filmDirector',
                'filmImage', 'filmRating']
  @@hash_global_and_local = {'filmTitle'=>'title', 'filmAbout'=>'about',
      'filmLength'=>'length', 'filmYear'=>'year', 'filmDirector'=>'director',
      'filmImage'=>'image', 'filmRating'=>'rating'}
  @@int_regexp = /^\d+$/


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

  def get_request_film()
    film = {}
    temp = @film.slice(:id, :name, :email, :password, :avatar)
    temp.each do |key, value|
      user[@@hash_local_and_global.key(key)] = value
    end
    film
  end

  def params_to_db_params(params)
    db_params = {}
    @@all_params.each do |key|
      db_params[@@hash_local_and_global[key]] = params[key]
    end
    db_params
  end

  def get_request_films()

  end

  def create_film()
    @@important_params.each do |key|
      if key == 'filmLength' || key = 'filmYear'
        check = is_parameter_valid key, param[key], @@int_regexp
      else
        check = is_parameter_valid key, param_key, nil
      end
      if check != true
        return render :json => {:respMsg => check}, :status => 400
      end
    end

    film = Film.new(params_to_db_params(params))
    if film.valid?
    begin
      film.save()
      return render :json => {:respMsg => "Ok"}, :status => 201
    rescue
        responseMessage = ReVsponseMessage.new("Database error")
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
    render :json => {'respMsg': 'Ok', 'film': get_request_film}
  end



  def get_films()
    param_names = ['page', 'count']
    param_names.each do |key|
      check = is_parameter_valid params[key], key, @@int_regexp
      if check != true
        return render :json => {:respMsg => check}, :status => 400
      end
    end

    count = Integer(params[:count])
    offset = Integer(params[:page])*count

    begin

    rescue
    end
  end

  def delete_film()
    id = params[:id]
    check_film_id = is_parameter_valid 'id', id, @int_regexp
    if check_film_id != true
        return render :json => {:respMsg => check_film_id}, :status => 400
    end

    begin
      film = Film.find_by_id(id)
      if film != nil
        Film.destroy(id)
        return render :json {:respMsg => "Ok"}, :status => 200
      end
      return render :json => {:respMsg => "No such film"}, :status => 404
    rescue
      responseMessage = ResponseMessage.new("Database error")
      return render :json => responseMessage, :status => 500
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
