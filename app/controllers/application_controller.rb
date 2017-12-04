class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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

  0

  def add_film()

  end

  def get_film()
    id = params[:id]
    check_film_id = is_parameter_valid 'id', id, nil
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
    render :json => @film#, :only => ['id', "avatar"]
  end

  def get_films()
  end

  def set_film_rating()

  end

  def update_film()

  end
end
