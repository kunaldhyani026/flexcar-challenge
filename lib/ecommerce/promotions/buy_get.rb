# frozen_string_literal: true

require_relative 'abstract_promotion'

module Ecommerce
  module Promotions
    # Concrete BuyGet Promotion class implementing AbstractPromotion interface
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
    end
  end
end

