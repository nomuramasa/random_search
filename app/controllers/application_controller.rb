class ApplicationController < ActionController::Base

	# 最初に呼び出す
  before_action :set_current_user

  # ログイン中のユーザー
 	def set_current_user
		@current_user = User.find_by(id: session[:user_id])
	end

end
