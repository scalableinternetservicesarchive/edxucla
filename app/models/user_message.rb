class UserMessage < ApplicationRecord
  validates :message, presence: true
end
