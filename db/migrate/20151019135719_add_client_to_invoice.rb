class AddClientToInvoice < ActiveRecord::Migration
 def change
	add_reference :invoices, :client, index: true
	add_foreign_key :invoices, :clients 
  end
end
