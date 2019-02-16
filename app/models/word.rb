class Word < ApplicationRecord
	validates :user_id, {presence:true} # ユーザーID 空はダメ
end
