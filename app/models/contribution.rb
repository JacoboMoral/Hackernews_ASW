class Contribution < ApplicationRecord
  acts_as_votable
  
  belongs_to :user
  has_many :comments
  validate :text_xor_url
  validate :url_is_valid

  private

  def text_xor_url
    unless text.blank? ^ url.blank?
      errors.add(:base, "Specify a text or a url, not both")
    end
  end

  def url_is_valid
    unless url.blank?
      unless url =~ /(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9]\.[^\s]{2,})/
        errors.add(:base, "URL must be valid")
      end
    end
  end
end
