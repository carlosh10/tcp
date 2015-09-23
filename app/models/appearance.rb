class Appearance < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :o
end
