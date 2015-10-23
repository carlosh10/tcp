class AddServicesToOs < ActiveRecord::Migration
  def change
  		add_reference :services, :o, index: true
		add_foreign_key :services, :os
  end
end
