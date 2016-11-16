class Conversation < ApplicationRecord
  def self.safe_find_or_create_by(*args, &block)
    find_or_create_by *args, &block
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end
