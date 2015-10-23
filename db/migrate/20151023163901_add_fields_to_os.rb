class AddFieldsToOs < ActiveRecord::Migration
  def change
    add_column :os, :ce, :string
    add_column :os, :di, :string
    add_column :os, :retirada, :datetime
    add_column :os, :cif_value, :float
    add_column :os, :total_value, :float
    
    add_column :os, :created, :datetime
    add_column :os, :number, :integer
    add_column :os, :turn , :integer
  end
end
