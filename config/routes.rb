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

  # Just adding route structure for understanding, as implementation is out of scope for current timelines
  #
  # Routes for promotion/add and promotion/edit -> to be handled by promotions_controller in future
  # resource :promotion, only: [] do
  #   post :add, :edit, on: :collection
  # end

  # Routes for item/add and item/edit -> to be handled by items_controller in future
  # resource :item, only: [] do
  #   post :add, :edit, on: :collection
  # end
end
