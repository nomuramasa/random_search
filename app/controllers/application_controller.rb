class ApplicationController < ActionController::Base

	# 最初に定義
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

	def forbid_login_user
		if @current_user
			flash[:notice] = 'すでにログインしています'
			redirect_to('/posts')
		end
	end

	def cannot_edit_info
		if @current_user.id.to_i != params[:id].to_i
			flash[:notice] = '他のユーザー情報は変更しないでください'
			redirect_to('/users')
		end
	end

	def donot_edit_otherones_post
		@post = Post.find_by(id: params[:id])
		if @current_user.id != @post.user_id
			flash[:notice] = '他のユーザーの投稿は変更しないでください'
			redirect_to("/posts")
			# redirect_to("/posts/#{params[:id]}") #投稿詳細にリダイレクト
		end			
	end



end
