class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_new = Book.new
    @book_comment = BookComment.new
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    # toは現在の日の終わり(23:59:59)、fromは6日前の始まり(00:00:00)を表しており、これらの間の期間で「いいね」された投稿を抽出しています。
    @books = Book.includes(:favorited_users).
    # book情報と関連するいいね情報が同時に取得されます
      sort_by {|book| 
      book.favorited_users.includes(:favorites).where(created_at: from...to).count
      }.reverse
      # sort_byメソッドは、配列やハッシュの要素を特定の基準に従って並べ替えるためのメソッドです。デフォルトでは昇順です。
      # 基準はブロックとして与えられ、ブロック内の処理結果に基づいて並べ替えが行われます。
      # booksの各要素（つまり各投稿）について、
      # 一週間以内に「いいね」された数を計算し、その数を基準にして投稿を並べ替えます。
      # 具体的には、book.favorited_users.includes(:favorites).where(created_at: from...to).countで一週間以内に「いいね」された数を取得し、
      # その数が多い順にbooksを並べ替えます。
      # .reverse：この部分は、sort_byによる並べ替えの結果を逆順にします。
      # つまり、「いいね」の数が多い投稿から順に並べ替えた結果を逆順にすることで、「いいね」の数が多い投稿を先頭にするリストを作成します。
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
    end
  end
  
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def ensure_correct_user
      @book = Book.find(params[:id])
      unless @book.user == current_user
        redirect_to books_path
      end
  end
end
