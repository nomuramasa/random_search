class TopController < ApplicationController
  def index
		# ランダムワードを生成
		@rand_url = 'https://ja.wikipedia.org/wiki/%E7%89%B9%E5%88%A5:%E3%81%8A%E3%81%BE%E3%81%8B%E3%81%9B%E8%A1%A8%E7%A4%BA' # Wikipediaおまかせ表示のURL。「https://ja.wikipedia.org/wiki/特別：おまかせ表示」と同じ。「https://ja.wikipedia.org/wiki/Special:Randompage」からのリダイレクト先

		require 'net/http'
	  @response = Net::HTTP.get_response(URI.parse(@rand_url))
	  @redi_url = @response['location'] # 最終リダイレクト。 ランダムワードを含むURL
	  @word = @redi_url.delete('https://ja.wikipedia.org/wiki/') # Wikipediaがランダムに探したワード
	  @word_ja = URI.decode(@word) # URL文字 → 読める言葉 にデコード

	  if @word_ja.include?('_')
	  	@word_ja = @word_ja.sub!(/_.*/m, '') # アンダーバー_以降を削除
	  end
  end
end
