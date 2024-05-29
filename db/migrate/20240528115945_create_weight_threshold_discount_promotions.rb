class CreateWeightThresholdDiscountPromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :weight_threshold_discount_promotions, id: false do |t|
      t.integer :id, primary_key: true, auto_increment: true
      t.references :promotion, null: false, foreign_key: true
      t.decimal :weight_threshold, null: false
      t.decimal :discount_percentage, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.references :item, null: true, foreign_key: true
      t.references :category, null: true, foreign_key: true

      t.timestamps
    end
  end
end
