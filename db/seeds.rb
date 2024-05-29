# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# creating categories
category_footwear = Category.create!(name: 'Footwear')
category_electronics = Category.create!(name: 'Electronics')
category_skincare = Category.create!(name: 'Skincare')

# creating brands
brand_nike = Brand.create!(name: 'Nike')
brand_puma = Brand.create!(name: 'Puma')
brand_samsung = Brand.create!(name: 'Samsung')
brand_apple = Brand.create!(name: 'Apple')
brand_lakme = Brand.create!(name: 'Lakme')
brand_cetaphil = Brand.create!(name: 'Cetaphil')

# creating items
Item.create!(name: 'Bathroom Slipper', price: 540.0, stock_balance: 4, brand_id: brand_nike.id,
             category_id: category_footwear.id)
Item.create!(name: 'Sports Shoes', price: 1200.0, stock_balance: 2, brand_id: brand_nike.id,
             category_id: category_footwear.id)
Item.create!(name: 'Room Slipper', price: 800.0, stock_balance: 5, brand_id: brand_puma.id,
             category_id: category_footwear.id)
Item.create!(name: 'RXS Sneaker', price: 6500.0, stock_balance: 2, brand_id: brand_puma.id,
             category_id: category_footwear.id)
Item.create!(name: 'Smartphone', price: 15_000.0, stock_balance: 10, brand_id: brand_samsung.id,
             category_id: category_electronics.id)
item_smartwatch = Item.create!(name: 'Smartwatch', price: 6000.0, stock_balance: 1, brand_id: brand_samsung.id,
                               category_id: category_electronics.id)
Item.create!(name: 'Front Load Washing Machine', price: 16_500.0, stock_balance: 1, brand_id: brand_samsung.id,
             category_id: category_electronics.id)
Item.create!(name: 'iPhone 14', price: 80_000.0, stock_balance: 5, brand_id: brand_apple.id,
             category_id: category_electronics.id)
item_cleanser = Item.create!(name: 'Face Cleanser', price: 400.0, stock_balance: 2, brand_id: brand_cetaphil.id,
                             category_id: category_skincare.id)
item_moisturiser = Item.create!(name: 'Body Moisturiser', price: 500.0, stock_balance: 6, brand_id: brand_cetaphil.id,
                                category_id: category_skincare.id)
item_perfume = Item.create!(name: 'Perfume', price: 600.0, stock_balance: 1, brand_id: brand_cetaphil.id,
             category_id: category_skincare.id)
item_color_palette = Item.create!(name: 'Color Palette', price: 2000.0, stock_balance: 2, brand_id: brand_lakme.id,
                                  category_id: category_skincare.id)
Item.create!(name: 'Banana Chips', price: 10.0, selling_unit: :weight, stock_balance: 200)
Item.create!(name: 'Mango Candy', price: 20.0, selling_unit: :weight, stock_balance: 1000)

# Creating Promotion Types
flat_fee_promo = Promotion.create!(name: 'Flat Fee Discount',
                                   description: 'This promotion offers flat fee discount (ex: 20 dollars off on an item)')
percent_promo = Promotion.create!(name: 'Percentage Discount',
                                  description: 'This promotion offers Percentage discount (ex: 10% of off an item)')
buy_get_promo = Promotion.create!(name: 'Buy X Get Y Discount',
                                  description: 'This promotion offers Buy X Get Y discount(ex:Buy 1 get one free, buy 3 get 1 50% off)')
weight_threshold_promo = Promotion.create!(name: 'Weight Threshold Discount',
                                           description: 'This promotion offers Weight threshold discounts
                                (ex: buy more than 100 grams and get 50% off the item)')

# Concrete Table inheritance database design
# Creating discounts on items and categories in their respective discount_promotions table
FlatFeeDiscountPromotion.create!(
  promotion_id: flat_fee_promo.id,
  discount_amount: 100.0,
  start_time: Time.now,
  end_time: Time.now + 10.days,
  item_id: item_moisturiser.id
)

FlatFeeDiscountPromotion.create!(
  promotion_id: flat_fee_promo.id,
  discount_amount: 50.0,
  start_time: Time.now,
  end_time: Time.now + 10.days,
  item_id: item_smartwatch.id
)

PercentageDiscountPromotion.create!(
  promotion_id: percent_promo.id,
  discount_percentage: 5,
  start_time: Time.now,
  end_time: Time.now + 30.days,
  category_id: category_footwear.id
)

BuyGetDiscountPromotion.create!(
  promotion_id: buy_get_promo.id,
  buy_quantity: 1,
  get_quantity: 1,
  start_time: Time.now,
  end_time: Time.now + 24.hours,
  item_id: item_color_palette.id
)

BuyGetDiscountPromotion.create!(
  promotion_id: buy_get_promo.id,
  buy_quantity: 3,
  get_quantity: 1,
  start_time: Time.now + 48.hours,
  item_id: item_perfume.id
)

WeightThresholdDiscountPromotion.create!(
  promotion_id: weight_threshold_promo.id,
  weight_threshold: 1000,
  discount_percentage: 20,
  start_time: Time.now,
  end_time: Time.now + 24.hours,
  item_id: item_cleanser.id
)