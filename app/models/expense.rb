class Expense < ActiveRecord::Base
  belongs_to :invoice
end
