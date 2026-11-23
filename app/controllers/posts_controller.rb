class PostsController < ApplicationController
  before_action :set_owned_post, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Current.user.posts.build
  end

  def create
    @post = Current.user.posts.build(post_params)

    if @post.save
      redirect_to post_path(@post),
                  notice: "投稿しました。",
                  status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post),
                  notice: "投稿を更新しました。",
                  status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!

    redirect_to posts_path,
                notice: "投稿を削除しました。",
                status: :see_other
  end

  private

  def set_owned_post
    @post = Current.user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end