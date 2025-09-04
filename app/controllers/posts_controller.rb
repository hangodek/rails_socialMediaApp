class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
    @user = @post.user
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Post not found"
  end
  def create
    @post = Post.new(add_post_params.merge(user: Current.user))

    if @post.save
      redirect_back_or_to(root_path)
    else
      redirect_back_or_to(fallback_location: root_path, alert: @post.errors.full_messages.to_sentence, status: :see_other)
    end
  end

  def edit
    @post = Post.find(params[:id])
    @user = @post.user

    unless @post.user == Current.user
      redirect_to post_path(@post), alert: "You can only edit your own posts"
    end
  end

  def update
    @post = Post.find(params[:id])

    unless @post.user == Current.user
      redirect_to post_path(@post), alert: "You can only edit your own posts"
      return
    end

    if @post.update(update_post_params)
      redirect_to post_path(@post), notice: "Post updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params.expect(:id))

    unless @post.user == Current.user
      redirect_to post_path(@post), alert: "You can only delete your own posts"
      return
    end

    if @post.destroy
      redirect_to user_path(@post.user), notice: "Post deleted successfully"
    else
      redirect_back_or_to(post_path(@post), alert: "Unable to delete post")
    end
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

  def update_post_params
    params.expect(post: [ :content ])
  end
end
