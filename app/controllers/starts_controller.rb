class StartsController < ApplicationController
  def root
  end

  def show
    if request.user_agent.include?("curl")
      render json: {message: "WebPuzzleへようこそ。ユーザー登録をお願いします。エンドポイントはこちら。/users"}
    else
      render json: {message: "curlコマンドでアクセスしてください"}
    end
  end
end
