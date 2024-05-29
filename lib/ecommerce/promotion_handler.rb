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
      'flat_fee' => Promotions::FlatFee,
      'percentage' => Promotions::Percentage,
      'buy_get' => Promotions::BuyGet,
      'weight_threshold' => Promotions::WeightThreshold
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

    # Future needs - Promotion handler can implement create_promotion, update_promotion methods which will call
    # their respective promotion class to save or update any discount promotion
    # just adding structure here, actual code is out of scope for current assignment timelines

    # def create_promotion(params)
    #   type = params[:promotion_type]
    #   PROMOTION_FACTORY[type].new(params).save
    # end


    # def update_promotion(params)
    #   type = params[:promotion_type]
    #   PROMOTION_FACTORY[type].new(params).update
    # end

    private

    # Selects maximum discount promotion for an item
    def find_best_discount(item, quantity)
      discount = 0
      PROMOTION_FACTORY.each do |_promotion_type, klass|
        discount = [discount, klass.new({}).max_discount(item, quantity)].max
      end
      discount * quantity
    end
  end
end
