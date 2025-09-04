class CommentsController < ApplicationController
  include Pagy::Backend
  def index
    @post = Post.find(params[:post_id])
    @pagy, @comments = pagy_countless(@post.comments.includes(:user))
  end

  def show
  end
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(add_comment_params.merge(user: Current.user))

    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          if request.referer&.include?("/posts/#{@post.id}")
            # If coming from post show page, prepend to comments container
            render turbo_stream: [
              turbo_stream.prepend("comments_container", partial: "comments/comment", locals: { comment: @comment }),
              turbo_stream.update("comments_count", @post.comments.count),
              turbo_stream.remove("no_comments_message")
            ]
          else
            # If coming from modal, use the original behavior
            render turbo_stream: turbo_stream.prepend(
              "comment_container_for_post_#{@post.id}",
              partial: "comments/comment",
              locals: { comment: @comment }
            )
          end
        end
        format.html { redirect_back_or_to(root_path) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
        format.html { redirect_back_or_to(root_path, alert: @comment.errors.full_messages.to_sentence) }
      end
    end
  end

  def update
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post

    if @comment.user == Current.user
      @comment.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("comment_#{@comment.id}"),
            turbo_stream.update("comments_count", @post.comments.count)
          ]
        end
        format.html { redirect_back_or_to(post_path(@post), notice: "Comment deleted successfully") }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash", locals: { alert: "You can only delete your own comments" })
        end
        format.html { redirect_back_or_to(post_path(@post), alert: "You can only delete your own comments") }
      end
    end
  end

  def like
    @comment = Comment.find(params[:id])
    @comment.likes.create(user: Current.user) unless @comment.likes.find_by(user: Current.user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: post_path(@comment.post)) }
    end
  end

  def unlike
    @comment = Comment.find(params[:id])
    @comment.likes.where(user: Current.user).destroy_all

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: post_path(@comment.post)) }
    end
  end

  private

  def add_comment_params
    params.expect(comment: [ :content ])
  end
end
