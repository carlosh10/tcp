class O < ActiveRecord::Base

has_many :invoices
belongs_to :client

end
