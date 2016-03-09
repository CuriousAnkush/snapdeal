class Product < ActiveRecord::Base
  validate presence: :name
end
