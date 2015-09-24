class AddClientToInvoices < ActiveRecord::Migration
  def change
    add_reference :invoices, :invoice, index: true
    add_foreign_key :invoices, :invoices
  end
end
