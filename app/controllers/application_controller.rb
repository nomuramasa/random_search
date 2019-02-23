class ApplicationController < ActionController::Base

	# まずは、ログイン中のユーザーをセット
  before_action :set_current_user


  ###### 全体

  # ログイン中のユーザーをセット
 	def set_current_user
		@current_user = User.find_by(id: session[:user_id])
		# session[:user_id] = nil # session削す
	end


	###### ワードに関するセキュリティ　

	# 他のユーザーが持つ単語に関して、影響を与えることは出来ません
	def donot_houch_other_users_word
		@word = Word.find_by(id: params[:id]) # 変えようとしてるワード
		@user = User.find_by(id: @word.user_id) # 変えようとしてるワードのuser_idのユーザー
		if @user.id != @current_user.id
			flash[:notice] = '他のユーザーが持つ単語に関して、影響を与えることは出来ません'
			redirect_to("/")
		end
	end
	# addメソッドに関しては、さすがに以下の@current_userのsessionをURLから操ることは出来ないから、セキュリティ大丈夫だと思う
	# Word.new(user_id: @current_user.id)



	###### ユーザーに関するセキュリティ　

	# ログインが必要です
	def authenticate_user
    if @current_user == nil # ログインしてなければ
      flash[:notice] = 'ログインが必要です'
      redirect_to('/login')
    end		
	end

	# すでにログインしています
	def alread_login
		if @current_user
			flash[:notice] = 'すでにログインしています'
			redirect_to('/')
		end
	end

	# 管理者用のページは見れません
	def only_owner
		if @current_user.email != 'nomura@mail.com' # 管理者のメールアドレス
			flash[:notice] = '管理者用のページは見れません'
			redirect_to("/user/#{@current_user.id}") # 自分の詳細ページに戻す
		end
	end

	# 他のユーザーの情報は、閲覧や編集はできません
	def cannot_edit
		if @current_user.id.to_i != params[:id].to_i
			flash[:notice] = '他のユーザーの情報は、閲覧や編集はできません'
			redirect_to("/user/#{@current_user.id}") # 自分の詳細ページに戻す
		end
	end





end
