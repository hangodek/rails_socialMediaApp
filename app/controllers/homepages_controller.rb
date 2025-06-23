class HomepagesController < ApplicationController
  def index
    if Current.user
      @posts = Current.user.posts.order(created_at: :desc)
    end
  end
end
