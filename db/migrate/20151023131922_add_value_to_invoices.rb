class AddValueToInvoices < ActiveRecord::Migration
  def change
  	    add_column :invoices, :value, :float
  end
end
