class Users::ActivationsController < ApplicationController
  def activation_help
    render json: {message: "Basic認証の情報を伝え忘れてました。ユーザー名はRailsを作ったデンマーク人の名前です。3文字です。パスワードは彼の創設した会社の名前です。どちらも半角小文字で入力してください。"}
  end

  def create
    @user = User.find_by(uuid: params[:user_uuid])
    secret_keyword = activation_params[:secret_keyword]

    if secret_keyword.blank?
      flash.now[:error_message] = "秘密のパスワードを入力してください。"
      render 'users/show'
    elsif secret_keyword == @user.uuid
      flash.now[:error_message] = "惜しい。その秘密のパスワードをBase64エンコードしてください。"
      render 'users/show'
    elsif secret_keyword == Base64.strict_encode64(@user.uuid)
      @user.update(activation: true)
      redirect_to new_post_path(uuid: @user.uuid)
    else
      flash.now[:error_message] = "秘密のパスワードが違います"
      render 'users/show'
    end
  end

  private
  def activation_params
    params.require(:user).permit(:name, :secret_keyword)
  end
end
