AngularBook::Application.routes.draw do

  root 'books#index'

  resources :books, except: [:new, :edit]

  get "books_templates/index", to: "books_templates#index"

end
