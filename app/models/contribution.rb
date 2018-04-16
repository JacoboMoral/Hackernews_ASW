class Contribution < ApplicationRecord
    #belongs_to :user

    validate :text_xor_url

  private

    def text_xor_url
      unless text.blank? ^ url.blank?
        errors.add(:base, "Specify a text or a url, not both")
      end
    end
end
