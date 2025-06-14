class HomepagesController < ApplicationController
  def index
    @posts = Current.user.posts.order(created_at: :desc)
  end
end
