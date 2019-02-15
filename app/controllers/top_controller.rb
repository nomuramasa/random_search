class TopController < ApplicationController

	#### 検索ワード一覧ページ表示
  def index
		@words = Word.all
  end

  #### 新ワード追加アクション
  def add

		# ランダムワードを生成（本来はcsvファイルなどから取得） 
		@rand_url = 'https://ja.wikipedia.org/wiki/%E7%89%B9%E5%88%A5:%E3%81%8A%E3%81%BE%E3%81%8B%E3%81%9B%E8%A1%A8%E7%A4%BA' # Wikipediaおまかせ表示のURL。「https://ja.wikipedia.org/wiki/特別：おまかせ表示」と同じ。「https://ja.wikipedia.org/wiki/Special:Randompage」からのリダイレクト先

		require 'net/http'
	  @response = Net::HTTP.get_response(URI.parse(@rand_url))
	  @redi_url = @response['location'] # 最終リダイレクト。 ランダムワードを含むURL
	  @word = @redi_url.delete('https://ja.wikipedia.org/wiki/') # Wikipediaがランダムに探したワード
	  @word_ja = URI.decode(@word) # URL文字 → 読める言葉 にデコード

	  if @word_ja.include?('_')
	  	@word_ja = @word_ja.sub!(/_.*/m, '') # アンダーバー_以降を削除
	  end

	  # データベースに保存
	  @word = Word.new(content:@word_ja, star:0, visit:0)
	  @word.save
	  redirect_to('/') # 終わったら一覧へ返す
  end

  #### 検索ワードをクリック
  def visit
		# 訪問したというフラグを立てる
		@word = Word.find_by(id:params[:id])
		@word.visit = 1
		@word.save  
		# 検索ワードに飛ぶ
	  # redirect_to('https://www.google.com/search?q='+@word.content) 
	  redirect_to('/') # 終わったら一覧へ返す
	end

  #### スター更新
  def update
    @word = Word.find_by(id:params[:id])
    if @word.star==0 then @word.star=1 else @word.star=0 end 
    @word.save
	  redirect_to('/') # 終わったら一覧へ返す
  end


  #### 削除
  def delete
    @word = Word.find_by(id:params[:id])
    @word.destroy
	  redirect_to('/') # 終わったら一覧へ返す
  end

end
