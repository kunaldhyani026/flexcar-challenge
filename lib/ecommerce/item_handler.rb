# frozen_string_literal: true

module Ecommerce
  # The ItemHandler class is responsible for managing items in inventory within the ecommerce platform.
  # It includes methods to add item, update item or remove item from inventory
  class ItemHandler

    def initialize(user_id)
      @user_id = user_id
    end

    # Future needs - Item handler will implement create_item, update_item, remove_item methods
    # just adding structure here, actual code is out of scope for current assignment timeline of 48 hours

    # Adds item to inventory
    # def create_item(params)
    #   to-do
    # end

    # Updates item present in inventory
    # def update_item(params)
    #   to-do
    # end

    # Remove item from inventory
    # def remove_item(params)
    #   to-do
    # end
  end
end

