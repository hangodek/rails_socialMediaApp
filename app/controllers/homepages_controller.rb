class HomepagesController < ApplicationController
  def index
    @posts = Current.user.posts
  end
end
