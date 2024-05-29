# frozen_string_literal: true

require_relative 'promotion_handler'

module Ecommerce
  # Represents a shopping cart handler in the ecommerce system.
  # This uses Rails memory_store cache, to keep the state of the cart per user_id
  # In production systems, some persistent memory store with time to live can be used.
  class CartHandler
    def initialize(user_id)
      @cart_name = "cart_#{user_id}"
      initialize_cart
      @promotion_handler = PromotionHandler.new(@cart_name)
    end

    # Adds item with specified quantity to the cart applying relevant promotions
    def add_item(item, quantity)
      current_cart = user_cart
      existing_item = get_item_from_cart(item, current_cart)
      existing_item ? existing_item[:quantity] += quantity : current_cart << { item_id: item.id, quantity: quantity }
      @promotion_handler.apply_promotion(current_cart)
      Rails.cache.write(@cart_name, current_cart)
      { 'status' => :ok, 'body' => { 'cart' => current_cart } }
    end

    # Removes item with specified quantity from the cart applying relevant promotions
    def remove_item(item, quantity)
      current_cart = user_cart
      existing_item = get_item_from_cart(item, current_cart)
      unless existing_item && existing_item[:quantity] >= quantity
        return { 'status' => :conflict, 'body' => { 'error' => "#{item.name} with #{quantity} quantity not present in cart" } }
      end

      existing_item[:quantity] -= quantity
      current_cart.delete(existing_item) if existing_item[:quantity].zero?
      @promotion_handler.apply_promotion(current_cart)
      Rails.cache.write(@cart_name, current_cart)
      { 'status' => :ok, 'body' => { 'cart' => current_cart } }
    end

    # Displays current_users cart with total cost and savings
    def view_cart
      current_cart = user_cart
      @promotion_handler.apply_promotion(current_cart)
      cart_cost = calculate_cart_cost(current_cart)
      { 'status' => :ok, 'body' => { 'cart_cost' => cart_cost, 'cart' => user_cart }}
    end

    private

    def initialize_cart
      return if user_cart.present?

      Rails.cache.write(@cart_name, [])
    end

    def user_cart
      Rails.cache.read(@cart_name)
    end

    def get_item_from_cart(item, cart)
      cart.find { |cart_item| cart_item[:item_id] == item.id }
    end

    def calculate_cart_cost(cart)
      total_actual_cost = 0
      total_savings = 0
      total_discounted_cost = 0
      cart.each do |cart_item|
        total_actual_cost += cart_item[:actual_cost]
        total_savings += cart_item[:savings]
        total_discounted_cost += cart_item[:discounted_cost]
      end
      { total_actual_cost:, total_discounted_cost:, total_savings: }
    end
  end
end
