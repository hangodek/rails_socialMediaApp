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

  private

  def add_post_params
    params.permit(:content, :user)
  end
end
