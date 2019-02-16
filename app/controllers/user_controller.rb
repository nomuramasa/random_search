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
  	@user = User.new
  end

  def create
  	@user = User.new(
      name:params[:name], 
      email:params[:email]
    )
  	if @user.save # 保存できたら、登録成功
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

    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end

  	if @user.save
  		flash[:notice] = 'ユーザー情報を変更しました'
  		redirect_to("/users/#{@user.id}")
  	else
  		render("users/edit")
  	end  	
  end

end
