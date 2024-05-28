class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items, id: false do |t|
      t.integer :id, primary_key: true, auto_increment: true
      t.string :name
      t.decimal :price
      t.decimal :weight
      t.integer :quantity
      t.references :category, null: true, foreign_key: true
      t.references :brand, null: true, foreign_key: true

      t.timestamps
    end
  end
end
