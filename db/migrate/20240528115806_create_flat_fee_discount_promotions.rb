class CreateFlatFeeDiscountPromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :flat_fee_discount_promotions, id: false do |t|
      t.integer :id, primary_key: true, auto_increment: true
      t.references :promotion, null: false, foreign_key: true
      t.decimal :discount_amount
      t.datetime :start_time
      t.datetime :end_time
      t.references :item, null: true, foreign_key: true
      t.references :category, null: true, foreign_key: true

      t.timestamps
    end
  end
end
