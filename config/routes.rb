Rails.application.routes.draw do
  get '/get_film/:id', to 'film#get_film', as :get_film
  get '/get_films/:page/:count', to 'film#get_films', as :get_films
  post '/add_film/', to 'film#create_film', as :add_film
  delete '/delete_film/', to 'film#delete_film', as :delete_film
  post '/update_film/', to 'film#update_film', as :update_film
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
