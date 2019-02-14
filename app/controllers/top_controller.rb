class TopController < ApplicationController
  def index
		# ランダムワードを生成
		@uri_str = 'https://ja.wikipedia.org/wiki/Special:Randompage'
		# @uri_str = 'https://ja.wordpress.org'
		require 'net/http'
		# require 'uri'

		# limit = 10s
		  # You should choose better exception.
		  # raise ArgumentError, 'HTTP redirect too deep' if limit == 0

	  @response = Net::HTTP.get_response(URI.parse(@uri_str))
	  @response["location"]
	  # case @response
	  # when Net::HTTPSuccess
	    # @response
	  # when Net::HTTPRedirection
	    # @response['location']
	  # else
	    # @response.value
	  # end
  end
end
