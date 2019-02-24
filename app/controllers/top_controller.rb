class TopController < ApplicationController

	# 他のユーザーが持つ単語に関して、影響を与えることは出来ません
  before_action :donot_houch_other_users_word, {only: [:visit, :update, :delete]}


  ####### 以下は全て、リンクを押すことでしか発生しない関数

	#### 検索ワード一覧ページ表示
  def index
  	
		# サイト切り替えのための、名と色をセット
		@sites = [
			[name: 'Google', color: 'dark'],
			[name: 'Youtube', color: 'danger'],
			[name: 'Twitter', color: 'primary']
		]
  	if @current_user # ログイン時のみ
	  	# @words = Word.all
			@words = Word.where(user_id: @current_user.id) # ログイン中のユーザーが生成したものだけ選択
			@words = @words.order(id: :desc) # 新しい順に並び替え

		end
  end

  #### 新ワード追加アクション
  def add

		# ランダムワードを生成（本来はcsvファイルなどから取得） 		
		ran_num = rand(100) # サイトを振り分ける為の乱数を生成


		### Wikipedia 50% 
		if ran_num < 40

			# rand_url = 'https://ja.wikipedia.org/wiki/Special:Randompage' 
			rand_url = 'https://ja.wikipedia.org/wiki/%E7%89%B9%E5%88%A5:%E3%81%8A%E3%81%BE%E3%81%8B%E3%81%9B%E8%A1%A8%E7%A4%BA' # Wikipediaおまかせ表示のURL


			require 'net/http'
		  response = Net::HTTP.get_response(URI.parse(rand_url))
		  redi_url = response['location'] # 最終リダイレクト。 ランダムワードを含むURL
		  word = redi_url.delete('https://ja.wikipedia.org/wiki/') # Wikipediaがランダムに探したワード
		  @word_ja = URI.decode(word) # URL文字 → 読める言葉 にデコード

		  if @word_ja.include?('_')
		  	@word_ja = @word_ja.sub!(/_.*/m, '') # アンダーバー_以降を削除
		  end
	  
	  ### weblio 50% 
	  elsif ran_num < 100  

	  	# rand_url = 'https://www.weblio.jp/content_find?random-select'
	  	rand_url = 'https://www.weblio.jp/WeblioRandomSelectServlet' 

			require 'net/http'
		  response = Net::HTTP.get_response(URI.parse(rand_url)) #<Net::HTTPFound:0x00007fb0dbbee5e0>
		  redi_url = response['location'] # https://www.weblio.jp/content/%E7%9C%9F%E9%8D%AE
		  word = redi_url.delete('https://www.weblio.jp/content/') # %E7%9C%9F%E9%8D%AE
		  @word_ja = URI.decode(word) # デコード

		  if @word_ja.include?('+')
		  	@word_ja = @word_ja.gsub(/\+/, ' ') # 「+」を全てスペースに置換
		  end
	  ### その他 50% 
	  # elsif ran_num < 100

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


  #### リンク先サイトを変える
  def change_site
  	session[:site] = params[:site] # パラメータをそのままセッションに代入
  	# render :json => {:session[:site] => @site}
  	redirect_to('/')
  end


	helper_method :add # routesからだけじゃなくviewからも呼び出したい

end
