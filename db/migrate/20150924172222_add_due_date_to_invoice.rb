class AddDueDateToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :due_date, :string
  end
end
