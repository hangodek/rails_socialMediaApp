class PostsController < ApplicationController
  def create
    @post = Post.new(add_post_params.merge(user: Current.user))

    if @post.save
      redirect_to root_path
    else
      redirect_to root_path, alert: @post.errors.full_messages.to_sentence
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def like
    @post = Post.find(params[:id])
    @post.likes.create(user: Current.user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def unlike
    @post = Post.find(params[:id])
    @post.likes.where(user: Current.user).destroy_all

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  private

  def add_post_params
    params.permit(:content, :user)
  end
end
