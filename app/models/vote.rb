class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :contributions
  has_many :votes
end
