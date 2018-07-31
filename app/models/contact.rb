class Contact < ApplicationRecord

  # Validatoin
  validates :title,
  	presence: true,
  	length: { maximum: 70,
              message: "件名は最大70文字まで入力できます" }

  validates :email,
  	presence: true,
  	length: { maximum: 2000,
              message: "本文は最大2000文字まで入力できます" }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
  	presence: true,
  	uniqueness: true,
    format: { with: VALID_EMAIL_REGEX,
      				message: "メールアドレスの記入内容を確認して下さい" }

  validates :status,
    format: { with: /\A\w(未確認|対応中|対応完了)\z/,
      				message: "無効な入力です" }

end
