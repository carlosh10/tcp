class Client < ActiveRecord::Base

has_many :invoices
has_many :os

end
