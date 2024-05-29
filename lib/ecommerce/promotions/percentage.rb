# frozen_string_literal: true

require_relative 'abstract_promotion'

module Ecommerce
  module Promotions
    # Concrete Percentage Promotion class implementing AbstractPromotion interface
    class Percentage < AbstractPromotion

      # calculates maximum active percentage discount for an item
      def max_discount(item, _quantity)
        maximum_discount = PercentageDiscountPromotion
                             .where('start_time <= ?', Time.current)
                             .where('end_time IS NULL OR end_time > ?', Time.current)
                             .where('item_id = ? OR category_id = ?', item.id, item.category_id)
                             .maximum(:discount_percentage)
        maximum_discount.present? ? (maximum_discount * item.price)/100 : 0
      end
    end
  end
end

