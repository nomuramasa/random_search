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

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
