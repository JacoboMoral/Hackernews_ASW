class Comment < ApplicationRecord
    validates :content, presence: true
    has_many :replies
    belongs_to :user
    belongs_to :contribution
end
