class User < ApplicationRecord
  has_many :contributions
  has_many :comments
end
