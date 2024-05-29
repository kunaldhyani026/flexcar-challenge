# frozen_string_literal: true

require_relative 'abstract_promotion'

module Ecommerce
  module Promotions
    # Concrete BuyGet Promotion class implementing AbstractPromotion interface
    # Anything specific to buyget promotions, this class will handle
    class BuyGet < AbstractPromotion

      # calculates maximum active buy_get discount for an item
      def max_discount(item, quantity)
        matching_promotions = BuyGetDiscountPromotion
                      .where('start_time <= ?', Time.current)
                      .where('end_time IS NULL OR end_time > ?', Time.current)
                      .where('item_id = ? OR category_id = ?', item.id, item.category_id)

        max_discount = matching_promotions.map do |promotion|
          item.price - ((promotion.buy_quantity * item.price) / (promotion.buy_quantity + promotion.get_quantity))
        end.max
        max_discount.present? ? max_discount : 0
      end

      # Implementing save and update method for understanding the code structure
      # just adding structure here, actual code is out of scope for current assignment timelines

      # def save
      #   to-do
      # end

      # def update
      #   to-do
      # end
    end
  end
end

