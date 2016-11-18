class Education < ApplicationRecord
	validates :name, presence: true
	validates :alias, presence: true
end
