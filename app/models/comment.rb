class Comment < ApplicationRecord
	acts_as_votable
    validates :content, presence: true
    has_many :replies
    belongs_to :user
    belongs_to :contribution
end
