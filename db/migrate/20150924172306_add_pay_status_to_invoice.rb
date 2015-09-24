class AddPayStatusToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :pay_status, :string
  end
end
