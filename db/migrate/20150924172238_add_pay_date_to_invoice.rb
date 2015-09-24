class AddPayDateToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :pay_date, :string
  end
end
