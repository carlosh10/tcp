class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :invoice_num
      t.string :invoice_url

      t.timestamps null: false
    end
  end
end
