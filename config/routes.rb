Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resource :cart, only: [] do
    # Define a collection route for adding and removing item(s) to the cart
    post :add, :remove, on: :collection
    # Route to view the cart
    get :show
  end
end
