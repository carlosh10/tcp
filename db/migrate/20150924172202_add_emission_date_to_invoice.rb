class AddEmissionDateToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :emission_date, :string
  end
end
