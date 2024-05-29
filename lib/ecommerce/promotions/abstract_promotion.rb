# frozen_string_literal: true

module Ecommerce
  module Promotions
    # Abstract class, to act as interface to every type of promotion class.
    # So If any new promotion comes up, it only need to implement these methods and rest of system will work.
    class AbstractPromotion

      # Create and save new promotion discount entry
      def save
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      # Update any active or expired promotion discount entry
      def update
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      # Show all active discounts
      def list
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      # Find maximum_discount out of all active discounts for this item
      def max_discount(_item_id, _added_quantity)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end
