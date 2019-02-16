class UserController < ApplicationController

 	# ユーザー一覧
  def index
  	@users = User.all
  end

 	# ユーザー詳細
  def show
  	@user = User.find_by(id:params[:id])
  end

 	# 新規登録
  def new
  	@user = User.new # 空定義
  end

  def create
  	@user = User.new(
      name:params[:name], 
      email:params[:email]
    )
  	if @user.save # 保存できたら、登録成功
			flash[:notice] = 'ユーザーを登録しました'
			redirect_to("/user/#{@user.id}") # 詳細ページへ
		else # 保存できなかったら、登録失敗
			render('user/new') # newアクションを経由せずに（createアクションの@userデータを持ったまま）直接、新規登録画面に
		end
  end

  # ユーザー編集
  def edit
  	@user = User.find_by(id:params[:id])
  end

  def update
  	@user = User.find_by(id:params[:id])
  	@user.name = params[:name]
    @user.email = params[:email]

  	if @user.save # 成功
  		flash[:notice] = 'ユーザー情報を変更しました'
  		redirect_to("/user/#{@user.id}")
  	else # 失敗
  		render("user/edit")
  	end
  end

  # ユーザー削除
  def delete
    @user = User.find_by(id:params[:id])
    @user.destroy 
    flash[:notice] = '退会しました'
	  redirect_to("/user") # ユーザー一覧ページへ
  end
end
