class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :description
      t.integer :weight
      t.integer :value
      t.string :cemaster
      t.string :cehouse
      t.string :di
      t.references :invoice, index: true

      t.timestamps null: false
    end
    add_foreign_key :expenses, :invoices
  end
end
