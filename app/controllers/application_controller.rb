class ApplicationController < ActionController::Base

	# さっそく、ログイン中のユーザーを定義するアクションを実行
  before_action :set_current_user


  # ログイン中のユーザー
 	def set_current_user
		@current_user = User.find_by(id: session[:user_id])
	end

	# ユーザー認証
	def authenticate_user
    if @current_user == nil # ログインしてなければ
      flash[:notice] = 'ログインが必要です'
      redirect_to('/login')
    end		
	end

	# ログイン済み
	def forbid_login_user
		if @current_user
			flash[:notice] = 'すでにログインしています'
			redirect_to('/')
		end
	end

	# 編集できない
	def cannot_edit_info
		if @current_user.id.to_i != params[:id].to_i
			flash[:notice] = '他のユーザーの情報は変更しないでください'
			redirect_to('/')
		end
	end


end
