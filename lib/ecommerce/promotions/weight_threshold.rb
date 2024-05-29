# frozen_string_literal: true

require_relative 'abstract_promotion'

module Ecommerce
  module Promotions
    # Concrete WeightThreshold Promotion class implementing AbstractPromotion interface
    class WeightThreshold < AbstractPromotion

      # calculates maximum active weight_threshold discount for an item
      def max_discount(item, quantity)
        return 0 unless item.selling_unit == 'weight'

        maximum_discount = WeightThresholdDiscountPromotion
                                .where('start_time <= ?', Time.current)
                                .where('end_time IS NULL OR end_time > ?', Time.current)
                                .where('item_id = ? OR category_id = ?', item.id, item.category_id)
                                .where('weight_threshold <= ?', quantity)
                                .maximum(:discount_percentage)
        maximum_discount.present? ? (maximum_discount * item.price)/100 : 0
      end
    end
  end
end

