Rottenpotatoes::Application.routes.draw do
  resources :movies do
    get 'similar_director', to: 'movies#similar_director'
  end
  root :to => redirect('/movies')
end
