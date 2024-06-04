class Users::ActivationsController < ApplicationController
  def activation_help
    render json: {message: "Basic認証の情報を伝え忘れてました。ユーザー名はRailsを作ったデンマーク人の名前です。3文字です。パスワードは彼の創設した会社の名前です。どちらも半角小文字で入力してください。"}
  end
end
