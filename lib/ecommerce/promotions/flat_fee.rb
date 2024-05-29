# frozen_string_literal: true

require_relative 'abstract_promotion'

module Ecommerce
  module Promotions
    # Concrete FlatFee Promotion class implementing AbstractPromotion interface
    class FlatFee < AbstractPromotion

      # calculates maximum active flat_fee discount for an item
      def max_discount(item, _quantity)
        maximum_discount = FlatFeeDiscountPromotion
          .where('start_time <= ?', Time.current)
          .where('end_time IS NULL OR end_time > ?', Time.current)
          .where('item_id = ? OR category_id = ?', item.id, item.category_id)
          .maximum(:discount_amount)
        maximum_discount.present? ? maximum_discount : 0
      end
    end
  end
end
