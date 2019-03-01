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
		require 'net/http'
	  
	  ### weblioリダイレクト 70% 
	  if ran_num < 70

	  	# rand_url = 'https://www.weblio.jp/content_find?random-select'
	  	rand_url = 'https://www.weblio.jp/WeblioRandomSelectServlet' 
		  response = Net::HTTP.get_response(URI.parse(rand_url)) #<Net::HTTPFound:0x00007fb0dbbee5e0>
		  redi_url = response['location'] # https://www.weblio.jp/content/%E7%9C%9F%E9%8D%AE
		  word = redi_url.delete('https://www.weblio.jp/content/') # %E7%9C%9F%E9%8D%AE
		  @word_ja = URI.decode(word) # デコード

		  if @word_ja.include?('+')
		  	@word_ja = @word_ja.gsub(/\+/, ' ') # 「+」を全てスペースに置換
		  end


		### Wikipediaリダイレクト 25% 
		elsif ran_num < 95

			# rand_url = 'https://ja.wikipedia.org/wiki/Special:Randompage' 
			rand_url = 'https://ja.wikipedia.org/wiki/%E7%89%B9%E5%88%A5:%E3%81%8A%E3%81%BE%E3%81%8B%E3%81%9B%E8%A1%A8%E7%A4%BA' # Wikipediaおまかせ表示のURL
		  response = Net::HTTP.get_response(URI.parse(rand_url))
		  redi_url = response['location'] # 最終リダイレクト。 ランダムワードを含むURL
		  word = redi_url.delete('https://ja.wikipedia.org/wiki/') # Wikipediaがランダムに探したワード
		  @word_ja = URI.decode(word) # URL文字 → 読める言葉 にデコード

		  if @word_ja.include?('_')
		  	@word_ja = @word_ja.sub!(/_.*/m, '') # アンダーバー_以降を削除
		  end


	  ### WikipediaAPI 5% 
	  elsif ran_num < 100

			# Wikipedia APIから単語を取得

			while 0 do # ちゃんとした単語を取得できる(breakになる)までループ
				uri = URI.parse('https://ja.wikipedia.org/w/api.php?action=query&format=json&list=random&rnlimit=1')
		    json = Net::HTTP.get(uri) # NET::HTTPを利用してAPIを叩く
		    result = JSON.parse(json) # 返り値を配列に変換
		    word = result['query']['random'][0]['title'] # 単語のみを取得

				## バリデート①  # 日本語が含まれない  # 〇〇が含まれる  # .が3つ(IPアドレス)
				if word !~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/\
					|| word.include?('利用者')\
					|| word.include?('出典を必要とする記事')\
					|| word.include?('ファイル')\
					|| word.include?('Wikipedia')\
					|| word.include?('の話題')\
					|| word.include?('カテゴリ')\
					|| word.include?('テンプレート')\
					|| word.include?('今日は何の日')\
					|| word.include?('メチ')\
					|| word.include?('依頼')\
					|| word.include?('削除')\
					|| word.include?('ログ')\
					|| word.include?('/')\
					|| word.count('.') == 3
					next # もう１度ループ
				else
					break # ループを抜ける（その単語でOK）
				end
			end


			## バリデート②  
			# コロン以前削除
			if word.include?(':') # :(コロン)が含まれる場合 
				word.sub!(/.*:/, '') # :(コロン)以前をsubで取り出して ''で削除 !は破壊的
			end

			# カッコ以降削除
			if word.include?('(') # (カッコが含まれる場合
				word.sub!(/\(.*/, '') # (カッコ以降を削除 \バックスラッシュでエスケープ
			end


			## バリデート③
			dusts = ['~', '/', '-', 'jawiki', 'doc', '良質ピックアップ', '最近の出来事', '関連一覧'] # ゴミ文字を決める

			dusts.each do |dust|
				if word.include?(dust) # ゴミ文字が含まれる場合
					word.sub!(/dust/, '') # 消す
				end
			end

			@word_ja = word # ちゃんと単語になったからviewに持っていく
	  end
	  # ワード取得終わり


	  if @current_user == nil # ログアウト中は、
		  render json: @word_ja # ajax通信でワードを返す


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
    # head :no_content # 何も起こさない
	  redirect_to('/') # トップページへ
  end


  #### リンク先サイトを変える
  def change_site
  	session[:site] = params[:site] # パラメータをそのままセッションに代入
  	redirect_to('/')
  	# @session = session[:site]
  	# render json: @session
  end

end
