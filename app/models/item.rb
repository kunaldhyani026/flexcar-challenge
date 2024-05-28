class Item < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :brand, optional: true
end
