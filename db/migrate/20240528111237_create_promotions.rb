class CreatePromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :promotions, id: false do |t|
      t.integer :id, primary_key: true, auto_increment: true
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
  end
end
