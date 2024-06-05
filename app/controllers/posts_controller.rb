class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    uuid = params[:uuid]
    if uuid.blank?
      render json: {message: "not found"}
    else
      @user = User.where(activation: true).where(uuid: uuid).take
      @post = @user.posts.new
      onetime_password = SecureRandom.hex(16)
      cookies['onetime_password'] = {value: onetime_password, expires: 1.hour.from_now }
    end
  end

  def create
    onetime_password = params[:post][:onetime_password]
    if onetime_password.blank?
      @post = Post.new(post_params)
      flash.now[:error_message] = "ワンタイムパスワードが必要です。ワンタイムパスワードはcookieに保存しておきました。nameはpost[onetime_password]としてこのフォームに埋め込んで送信してください。あえて入力フォームは用意していませんので開発者ツールで無理やり作ってください。"
      render :new, status: :unprocessable_entity
    elsif onetime_password != cookies['onetime_password']
      @post = Post.new(post_params)
      flash.now[:error_message] = "ワンタイムパスワードが違います。"
      render :new, status: :unprocessable_entity
    elsif onetime_password == cookies['onetime_password']
      uuid = params[:uuid]
      @user = User.where(activation: true).where(uuid: uuid).take
      @post = @user.posts.build(post_params)
      if @post.save
        redirect_to posts_path
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  private
  def post_params
    params.require(:post).permit(:body)
  end
end
