class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :client_code
      t.string :client_name

      t.timestamps null: false
    end
  end
end
