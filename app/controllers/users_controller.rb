class UsersController < ApplicationController
  before_action :check_token, only: [:create]
  before_action :basic_auth, only: [:show]
  skip_before_action :verify_authenticity_token, only: [:create]

  def uncorrect_http_method
    render json: {message: "HTTPメソッド、それであってる？"}
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: {message: "ユーザーの仮登録が完了しました。本登録をするためにブラウザで http://localhost:3000/users/#{@user.uuid} にアクセスしてください。何か困ったら http://localhost:3000/users/activation_help にアクセスしてください。"}
    else
      render json: {message: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(uuid: params[:uuid])
  end

  private
  def user_params
    params.permit(:name)
  end

  def check_token
    token = request.headers['Authorization']&.split(' ')&.last
    today = Date.today.strftime('%Y-%m-%d')

    if token.blank?
      render json: {message: "伝え忘れてました。一応簡易的な認証機能をつけてます。AuthorizationヘッダーにBearerトークンを設定してください。トークンは本日の日付です。フォーマットはyyyy-mm-ddです。"}
    elsif token != today
      render json: {message: "Bearerトークンを正しく設定してください。トークンは本日の日付です。フォーマットはyyyy-mm-ddです。"}
    end
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials.basic_auth[:username] && password == Rails.application.credentials.basic_auth[:password]
    end
  end
end
