class HomepagesController < ApplicationController
  include Pagy::Backend
  def index
    if Current.user
      # @posts = Current.user.posts.order(created_at: :desc) This N+1 Queries, so freaking lag, below is the better way
      @pagy, @posts = pagy_countless(Post.includes(:rich_text_content, :likes, comments: [ :user, user: { avatar_attachment: :blob } ], rich_text_content: { embeds_attachments: :blob }).where(user: [ Current.user, Current.user.followings ]).order(created_at: :desc))

      @suggested_users = User.where.not(id: Current.user.id).preload(avatar_attachment: :blob).order("RANDOM()").limit(3)
    end
  end
end
