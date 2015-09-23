class CreateAppearances < ActiveRecord::Migration
  def change
    create_table :appearances do |t|
      t.references :invoice, index: true
      t.references :o, index: true

      t.timestamps null: false
    end
    add_foreign_key :appearances, :invoices
    add_foreign_key :appearances, :os
  end
end
