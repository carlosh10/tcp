class AddServiceToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :service, :string
  end
end
