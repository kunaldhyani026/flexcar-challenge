# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_05_28_115945) do
  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buy_get_discount_promotions", force: :cascade do |t|
    t.integer "promotion_id", null: false
    t.integer "buy_quantity", null: false
    t.integer "get_quantity", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.integer "item_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_buy_get_discount_promotions_on_category_id"
    t.index ["item_id"], name: "index_buy_get_discount_promotions_on_item_id"
    t.index ["promotion_id"], name: "index_buy_get_discount_promotions_on_promotion_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flat_fee_discount_promotions", force: :cascade do |t|
    t.integer "promotion_id", null: false
    t.decimal "discount_amount", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.integer "item_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_flat_fee_discount_promotions_on_category_id"
    t.index ["item_id"], name: "index_flat_fee_discount_promotions_on_item_id"
    t.index ["promotion_id"], name: "index_flat_fee_discount_promotions_on_promotion_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.string "selling_unit", default: "quantity", null: false
    t.integer "stock_balance"
    t.integer "category_id"
    t.integer "brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_items_on_brand_id"
    t.index ["category_id"], name: "index_items_on_category_id"
  end

  create_table "percentage_discount_promotions", force: :cascade do |t|
    t.integer "promotion_id", null: false
    t.decimal "discount_percentage", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.integer "item_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_percentage_discount_promotions_on_category_id"
    t.index ["item_id"], name: "index_percentage_discount_promotions_on_item_id"
    t.index ["promotion_id"], name: "index_percentage_discount_promotions_on_promotion_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weight_threshold_discount_promotions", force: :cascade do |t|
    t.integer "promotion_id", null: false
    t.decimal "weight_threshold", null: false
    t.decimal "discount_percentage", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.integer "item_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_weight_threshold_discount_promotions_on_category_id"
    t.index ["item_id"], name: "index_weight_threshold_discount_promotions_on_item_id"
    t.index ["promotion_id"], name: "index_weight_threshold_discount_promotions_on_promotion_id"
  end

  add_foreign_key "buy_get_discount_promotions", "categories"
  add_foreign_key "buy_get_discount_promotions", "items"
  add_foreign_key "buy_get_discount_promotions", "promotions"
  add_foreign_key "flat_fee_discount_promotions", "categories"
  add_foreign_key "flat_fee_discount_promotions", "items"
  add_foreign_key "flat_fee_discount_promotions", "promotions"
  add_foreign_key "items", "brands"
  add_foreign_key "items", "categories"
  add_foreign_key "percentage_discount_promotions", "categories"
  add_foreign_key "percentage_discount_promotions", "items"
  add_foreign_key "percentage_discount_promotions", "promotions"
  add_foreign_key "weight_threshold_discount_promotions", "categories"
  add_foreign_key "weight_threshold_discount_promotions", "items"
  add_foreign_key "weight_threshold_discount_promotions", "promotions"
end
