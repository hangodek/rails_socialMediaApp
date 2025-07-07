class CommentsController < ApplicationController
  def index
  end

  def show
  end
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(add_comment_params.merge(user: Current.user))

    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend(
            "comment_container_for_post_#{@post.id}",
            partial: "comments/comment",
            locals: { comment: @comment }
          )
        end
        format.html { redirect_back_or_to(root_path) }
      end
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
