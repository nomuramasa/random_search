class User < ApplicationRecord

	has_secure_password # パスワードの暗号化

	validates :name, {presence:true} # 名前空はダメ
	validates :email, {presence:true} # メールアドレス空はダメ
	validates :email, {uniqueness:true} # メールアドレス重複はダメ
	validates :password, {presence:true} # パスワード空はダメ

end
