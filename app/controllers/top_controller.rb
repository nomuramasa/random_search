class TopController < ApplicationController
  def index
		# ランダムワードを生成
		function makeWord(){

			$rand_url = 'https://ja.wikipedia.org/wiki/Special:Randompage'; # Wikipediaおまかせ表示のURL
			$headers = get_headers($rand_url, 1); # 1はヘッダーのデータを連想配列にして返す
			$redi_url = array_pop($headers['Location']); # リダイレクト先のURL

			$word = str_replace('https://ja.wikipedia.org/wiki/', '', $redi_url); # Wikipediaがランダムに探したワード
			$word_ja = urldecode($word); # URL文字 → 読める言葉 にデコード

			if(strpos($word_ja, '_') !== false){ # _（アンダーバー）が含まれる場合
				$word_ja = strstr($word_ja, '_', true); # _（アンダーバー）以降を省略
			}
			return $word_ja;
			
		}
  end
end
