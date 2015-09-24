class AddOToInvoice < ActiveRecord::Migration
  def change
    add_reference :invoices, :o, index: true
    add_foreign_key :invoices, :os
  end
end
