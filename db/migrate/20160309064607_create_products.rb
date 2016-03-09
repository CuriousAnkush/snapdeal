class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :collection_id
      t.string :sku_id
      t.text :vars
      t.decimal :price
      t.text :description
      t.date :expire_date

      t.timestamps null: false
    end
  end
end
