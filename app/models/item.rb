class Item < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :brand, optional: true

  enum selling_unit: { quantity: 'quantity', weight: 'weight' }
end
