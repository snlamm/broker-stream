class DealSheet < ApplicationRecord
  serialize :details, Hash
  # ex. x = DealSheet.new, x.details = {first: "second"}

  before_create :confirmation_token

  private
  def confirmation_token
       if self.confirm_token.blank?
          self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
  end
end
