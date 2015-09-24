class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :client_code
      t.string :client_name
      t.string :client_address
      t.string :client_cep

      t.timestamps null: false
    end
  end
end
