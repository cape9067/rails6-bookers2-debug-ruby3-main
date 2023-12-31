class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_one_attached :profile_image
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :rooms, through: :participants
  has_many :chats, dependent: :destroy
  has_many :entries, dependent: :destroy
 
  validates :name, length: { minimum: 2, maximum: 20 }, presence: true, uniqueness: true
  validates :introduction, length: { maximum: 50 }
 
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  
  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  
  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  def self.search_for(content, method)
    if method == 'perfect'
      # 完全一致検索　content と完全に一致するタイトルを持つレコードを検索
      User.where(name: content)
    elsif method == 'forward'
      # 前方一致検索　content で指定された文字列で始まるタイトルを持つレコードを検索
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      # 後方一致検索　content で指定された文字列で終わるタイトルを持つレコードを検索
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
      # 部分一致検索。content で指定された文字列を含むタイトルを持つレコードを検索します。
    end
  end
end
