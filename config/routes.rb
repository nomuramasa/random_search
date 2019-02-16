Rails.application.routes.draw do

  ####### トップページ

  # 検索ワード一覧
  get '/' => 'top#index'

  # 新しく追加
  get '/add' => 'top#add'

  # 訪問した
  get '/:id/visit' => 'top#visit'

  # スター更新
  get '/:id/update' => 'top#update'

  # 削除
  get '/:id/delete' => 'top#delete'



  ####### ユーザー

  # 一覧
  get '/user' => 'user#index'

  # 新規
  get '/signup' => 'user#new'
  post '/user/create' => 'user#create'

  # 編集
  get '/user/:id/edit' => 'user#edit'
  post '/user/:id/update' => 'user#update'

  # 退会
  get '/user/:id/delete' => 'user#delete'
  
  # 詳細
  get '/user/:id' => 'user#show'



  ####### ログイン

  # ログイン
  get 'login' => 'user#login_form'
  post 'login' => 'user#login'

  # ログアウト
  get '/logout' => 'user#logout'



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
