class Room < ApplicationRecord
  belongs_to :user
  has_many :entries
  has_many :messages
end
