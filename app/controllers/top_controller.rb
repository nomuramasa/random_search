class TopController < ApplicationController

	# 他のユーザーが持つ単語に関して、影響を与えることは出来ません
  before_action :donot_houch_other_users_word, {only: [:visit, :update, :delete]}


  ####### 以下は全て、リンクを押すことでしか発生しない関数

	#### 検索ワード一覧ページ表示
  def index
  	if @current_user
	  	# @words = Word.all
			@words = Word.where(user_id: @current_user.id) # ログイン中のユーザーが生成したものだけ選択
			@words = @words.order(id: :desc) # 新しい順に並び替え
		end
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
	  

	  if @current_user == nil # ログアウト中は、
	  	return @word_ja # ランダム生成した、このワードが必要なので返す（ローカルストレージの方へ入れるから）

	  else # ログイン中は、
		  @word = Word.new( # データベースに保存
		  	content: @word_ja,
		  	star: 0,
		  	visit: 0,
		  	user_id: @current_user.id 
		  )
		  @word.save
		  redirect_to('/') # トップページへ
		end
  end

  #### 検索ワードをクリック
  def visit
		# 訪問したというフラグを立てる
		@word = Word.find_by(id:params[:id])
		@word.visit = 1
		@word.save  
	  redirect_to('/') # トップページへ
	end

  #### スター更新
  def update
    @word = Word.find_by(id:params[:id])
    if @word.star==0 then @word.star=1 else @word.star=0 end 
    @word.save
	  redirect_to('/') # トップページへ
  end


  #### 削除
  def delete
    @word = Word.find_by(id:params[:id])
    @word.destroy
	  redirect_to('/') # トップページへ
  end


	helper_method :add # routesからだけじゃなくviewからも呼び出したい

end
