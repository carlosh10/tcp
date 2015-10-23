class AddHistoricsToOs < ActiveRecord::Migration
  def change
  	  		add_reference :historics, :o, index: true
		add_foreign_key :historics, :os
  end
end
