class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @model = params[:model]
    # ユーザーが選択した検索対象のモデル（"user" または "book"）を @model 変数に代入
    @content = params[:content]
    # ユーザーが入力した検索キーワードを @content 変数に代入
    @method = params[:method]
    # ユーザーが選択した検索方法（"perfect"、"forward"、"backward"、"partial"）を @method 変数に代入
    
    # 選択したモデルに応じて検索を実行
    if @model  == "user"
      # 選択されたモデルが "user" である場合の条件分岐。ユーザーの検索を行う。
      @records = User.search_for(@content, @method)
      # 選択された検索対象（ユーザー）に対して、search_forメソッドを呼び出して検索を実行し、結果を@records変数に代入
    else
      # 上記の条件に当てはまらない場合の条件分岐。"book"の検索を行う。
      @records = Books.search_for(@content, @method)
      # 選択された検索対象（本）に対して、search_forメソッドを呼び出して検索を実行し、結果を@records変数に代入
    end
  end
end
