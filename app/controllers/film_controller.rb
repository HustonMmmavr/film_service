require 'responseMessage.rb'
require_dependency "#{Rails.root.join('app', 'services', 'consumer.rb')}"
require 'securerandom'
class FilmController < ApplicationController
  @@important_params = ['filmTitle', 'filmAbout', 'filmLength', 'filmYear', 'filmDirector']
  @@all_params = ['filmTitle', 'filmAbout', 'filmLength', 'filmYear', 'filmDirector',
                'filmImage', 'filmRating']
  @@hash_global_and_local = {'filmId' => 'id', 'filmTitle'=>'title', 'filmAbout'=>'about',
      'filmLength'=>'length', 'filmYear'=>'year', 'filmDirector'=>'director',
      'filmImage'=>'image', 'filmRating'=>'rating'}
  @@int_regexp = /\A[-+]?[0-9]+\z/
  @@rating_regexp = /^[+-]?([1-9]\d*|0)(\.\d+)?$/

  def check_token_valid(token)
    data = token.split(' ')

    appSecret = data[1]
    p data
    if rec = AccessApplication.where(:appToken => appSecret).first#:appName => appId, :appSecret => appSecret).first
      p rec
      now = Time.now.to_i
      created = rec['created'].to_i
      if now - created > rec['life']
        return false
      end
      return true
    else
      return 'uncknown'
    end
  end

  def is_parameter_valid(param_name, param, regexp)
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
    temp = @film.slice(:id, :title, :about, :length, :image, :rating, :director, :year)
    temp.each do |key, value|
      film[@@hash_global_and_local.key(key)] = value
    end
    film
  end

  def params_to_db_params(params)
    db_params = {}
    @@all_params.each do |key|
      db_params[@@hash_global_and_local[key]] = params[key]
    end
    db_params
  end

  def get_request_films(films)
    needed_params = ['filmRating', 'filmId', 'filmTitle', 'filmImage']
    out_films = []
    p Consumer.list
    films.each do |film|
      out_film = {}
      needed_params.each do |key|
        out_film[key] = film[@@hash_global_and_local[key]]
      end
      out_films.push(out_film)
    end
    out_films
  end

###############################################################
#### controllers
#############################################################
  def get_new_token()
    token = request.headers['Authorization']
    p token
    data = token.split(' ')
    data = data[1].split(':')#.split[':']

    appId = data[0]
    appSecret = data[1]
    p appSecret

    if appRec = AccessApplication.where(:appName => appId, :appSecret => appSecret)
      token = SecureRandom.hex#SecureRandom.base64 #=> "6BbW0pxO0YENxn38HMUbcQ=="
      created = Time.now
      life = 60
      appRec.update(:appToken => token, :created => created, :life => life)
      render :json => {:token => token}, :status => 200
    else
      render :json => {:respMsg => "Uncknown service"}, :status => 401
    end
  end


  def create_film()
    p request.headers['Authorization']
    if (data = check_token_valid(request.headers['Authorization'])) == false
      p data
      return render :json => {:respMsg => "Not authorized"}, status: 401
    else
      if data == 'uncknown'
        return render :json => {:respMsg => "Uncknown server"}, :status => 401
      end
    end

    @@important_params.each do |key|
      if key == 'filmLength' || key == 'filmYear'
        check = is_parameter_valid key, params[key], @@int_regexp
      else
        check = is_parameter_valid key, params[key], nil
      end
      if check != true
        return render :json => {:respMsg => check}, :status => 400
      end
    end

    db_params = params_to_db_params(params)
    db_params['rating'] = 0
    film = Film.new(db_params)
    begin
      film.save()
    rescue
      responseMessage = ResponseMessage.new("Database error")
      return render :json => responseMessage, :status => 500
    end
    p film
    render :json => {:respMsg => "Ok", :data => film.id}, :status => 201
  end

  def status()
    render :json => {:respMsg => "alive"}, status: 200
  end

  #return one film
  def get_film()
    if (data = check_token_valid(request.headers['Authorization'])) == false
      return render :json => {:respMsg => "Not authorized"}, status: 401
    else
      if data == 'uncknown'
        return render :json => {:respMsg => "Uncknown server"}, :status => 401
      end
    end
    # if !check_token_valid params[:appSecret]
    #   return render :json => {:respMsg => "Not authoeized"}, status: 401
    # end

    id = params[:id]
    check_film_id = is_parameter_valid 'id', id, @@int_regexp
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

  def get_films_count()
    if data = check_token_valid(request.headers['Authorization']) == false
      return render :json => {:respMsg => "Not authorized"}, status: 401
    else
      if data == 'uncknown'
        return render :json => {:respMsg => "Uncknown server"}, :status => 401
      end
    end

    begin
      cnt = Film.count()
    rescue
      responseMessage = ResponseMessage.new("Database error")
      return render :json => responseMessage, :status => 500
    end
    render :json => {:respMsg => "Ok", :filmsCount => cnt}, :status => 200
  end

  def get_films()
    if (data = check_token_valid(request.headers['Authorization'])) == false
      return render :json => {:respMsg => "Not authorized"}, status: 401
    else
      if data == 'uncknown'
        return render :json => {:respMsg => "Uncknown server"}, :status => 401
      end
    end

    param_names = ['offset', 'limit']
    param_names.each do |key|
      check = is_parameter_valid key, params[key], @@int_regexp
      if check != true
        return render :json => {:respMsg => check}, :status => 400
      end
    end

    limit = Integer(params[:limit])
    offset = Integer(params[:offset])

    begin
      films = Film.offset(offset).limit(limit)
      return render :json => {:respMsg => "Ok", :films => get_request_films(films) }, :status => 200
    rescue
      responseMessage = ResponseMessage.new("Database error")
      return render :json => responseMessage, :status => 500
    end
  end

  def delete_film()
    if (data = check_token_valid(request.headers['Authorization'])) == false
      return render :json => {:respMsg => "Not authorized"}, status: 401
    else
      if data == 'uncknown'
        return render :json => {:respMsg => "Uncknown server"}, :status => 401
      end
    end

    id = params[:filmId]
    check_film_id = is_parameter_valid 'filmId', id, @@int_regexp
    if check_film_id != true
        return render :json => {:respMsg => check_film_id}, :status => 400
    end

    begin
      film = Film.find_by_id(id)
      if film != nil
        Film.destroy(id)
        return render :json => {:respMsg => "Ok"}, :status => 200
      end
      return render :json => {:respMsg => "No such film"}, :status => 404
    rescue
      responseMessage = ResponseMessage.new("Database error")
      return render :json => responseMessage, :status => 500
    end
  end

  def update_film()
    if (data = check_token_valid(request.headers['Authorization'])) == false
      return render :json => {:respMsg => "Not authorized"}, status: 401
    else
      if data == 'uncknown'
        return render :json => {:respMsg => "Uncknown server"}, :status => 401
      end
    end

    update_fields = {}
    id = params[:filmId]
    if id == nil
      return render :json => {:respMsg => "no film specified"}, :status => 400
    end

    @@all_params.each do |key|
      param = params[key]
      check = true
      if param != nil
        if key == 'filmLength' || key == 'filmYear'
          check = is_parameter_valid key, param, @@int_regexp
        else
          if key == 'filmRating'
            check = is_parameter_valid key, param, @@rating_regexp
          end
        end
        if check != true
          return render :json => {:respMsg => check}, :status => 400
        end
        update_fields[@@hash_global_and_local[key]] = param
      end
    end

    begin
      film = Film.find_by_id(id)
      if film == nil
        return render :json => {:respMsg => "No film to update"}, :status => 404
      end
      Film.update(id, update_fields)
    rescue
      responseMessage = ResponseMessage.new("Database error")
      return render :json => responseMessage, :status => 500
    end
    render :json => {:respMsg => "Ok"}, :status => 200
  end
end
