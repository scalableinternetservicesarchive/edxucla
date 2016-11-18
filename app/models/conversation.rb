class Conversation < ApplicationRecord
  def self.safe_find_or_create_by(*args, &block)
    find_or_create_by *args, &block
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def self.safe_where_or_create_by(*args, &block)
    arg1 = *args[0][:user_one]
    arg2 = *args[0][:user_two]
    result = find_by user_one: arg1, user_two: arg2
    if result.nil?
      puts "nil"
      result = find_by user_one: arg2, user_two: arg1
      if result.nil?
        result = create *args
        return result
      end
    end

    return result

  rescue ActiveRecord::RecordNotUnique
    retry
  end
end
