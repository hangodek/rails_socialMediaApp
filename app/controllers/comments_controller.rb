class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(add_comment_params.merge(user: Current.user))

    if @comment.save
      redirect_to homepages_path
    end
  end

  def update
  end

  def destroy
  end

  private

  def add_comment_params
    params.expect(comment: [ :content ])
  end
end
