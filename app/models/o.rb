class O < ActiveRecord::Base

has_many :invoices

has_many :services

has_many :historics

belongs_to :client

end
