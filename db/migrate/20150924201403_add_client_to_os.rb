class AddClientToOs < ActiveRecord::Migration
  def change
    add_reference :os, :client, index: true
    add_foreign_key :os, :clients
  end
end
