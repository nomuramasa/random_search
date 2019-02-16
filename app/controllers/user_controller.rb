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
      email:params[:email], 
      password:params[:password], 
      image_name:'cat.jpg')
  	if @user.save
		flash[:notice] = 'ユーザーを登録しました'
    session[:user_id] = @user.id
		redirect_to("/users/#{@user.id}")
	else
		render('users/new')
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
