Rails.application.routes.draw do

  ####### トップページ

  # 検索ワード一覧
  get '/' => 'top#index'

  # 新しく追加
  post '/add' => 'top#add'

  # 削除
  post '/:id/delete' => 'top#delete'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
