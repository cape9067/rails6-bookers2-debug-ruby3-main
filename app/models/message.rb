class Message < ApplicationRecord
  
  belongs_to :user
  belongs_to :room
  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  def content
    self.message
  end
end
