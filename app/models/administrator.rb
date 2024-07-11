class Administrator < ApplicationRecord
  devise :database_authenticatable, :validatable
end
