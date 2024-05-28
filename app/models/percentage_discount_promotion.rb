class PercentageDiscountPromotion < ApplicationRecord
  include ItemOrCategoryPresence

  belongs_to :promotion
  belongs_to :item, optional: true
  belongs_to :category, optional: true
end
