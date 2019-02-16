class User < ApplicationRecord

	validates :name, {presence:true} # 名前空はダメ
	validates :email, {presence:true} # メールアドレス空はダメ
	validates :email, {uniqueness:true} # メールアドレス重複はダメ

end
