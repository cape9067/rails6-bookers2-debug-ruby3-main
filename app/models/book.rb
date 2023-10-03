class Book < ApplicationRecord
   has_one_attached :image
  belongs_to :user
  has_one_attached :profile_image
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
end
