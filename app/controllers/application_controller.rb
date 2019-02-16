class ApplicationController < ActionController::Base

	# 早速、ログイン中のユーザーを定義
  before_action :set_current_user

  # ログイン中のユーザー
 	def set_current_user
		@current_user = User.find_by(id: session[:user_id])
	end


	# ログインが必要です
	def authenticate_user
    if @current_user == nil # ログインしてなければ
      flash[:notice] = 'ログインが必要です'
      redirect_to('/login')
    end		
	end

	# すでにログインしています
	def forbid_login_user
		if @current_user
			flash[:notice] = 'すでにログインしています'
			redirect_to('/')
		end
	end

	# 管理者用のページは閲覧できません
	def only_owner
		if @current_user # ログインしてる場合
			if @current_user.id.to_i != 1.to_i # ID1は管理者
				flash[:notice] = '管理者用のページは閲覧できません'
				redirect_to('/')
			end
		else # ログインしてない場合
			flash[:notice] = '管理者用のページは閲覧できません'
			redirect_to('/')
		end	
	end

	# 他のユーザーの情報は、閲覧や編集はできません
	def cannot_edit_info
		if @current_user # ログインしてる場合
			if @current_user.id.to_i != params[:id].to_i
				flash[:notice] = '他のユーザーの情報は、閲覧や編集はできません'
				redirect_to('/')
			end
		else # ログインしてない場合
			flash[:notice] = '他のユーザーの情報は、閲覧や編集はできません'
			redirect_to('/')
		end
	end



end
