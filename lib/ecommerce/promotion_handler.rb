# frozen_string_literal: true

require_relative 'promotions/flat_fee'
require_relative 'promotions/percentage'
require_relative 'promotions/buy_get'
require_relative 'promotions/weight_threshold'

module Ecommerce
  # The PromotionHandler class is responsible for managing promotions within the ecommerce platform.
  # It includes methods to calculate the maximum discount for the cart items based on all active promotions.
  class PromotionHandler
    PROMOTION_FACTORY = {
      'flat_fee' => Promotions::FlatFee.new,
      'percentage' => Promotions::Percentage.new,
      'buy_get' => Promotions::BuyGet.new,
      'weight_threshold' => Promotions::WeightThreshold.new
    }.freeze

    def initialize(cart_name)
      @cart_name = cart_name
    end

    # Applies best promotions to the cart
    def apply_promotion(current_cart)
      current_cart.each do |cart_item|
        item = Item.find(cart_item[:item_id])
        best_discount = find_best_discount(item, cart_item[:quantity])
        cart_item[:actual_cost] = item.price * cart_item[:quantity]
        cart_item[:discounted_cost] = cart_item[:actual_cost] - best_discount
        cart_item[:savings] = best_discount
      end
      current_cart
    end

    private

    # Selects maximum discount promotion for an item
    def find_best_discount(item, quantity)
      discount = 0
      PROMOTION_FACTORY.each do |_promotion_type, klass|
        discount = [discount, klass.max_discount(item, quantity)].max
      end
      discount * quantity
    end
  end
end
