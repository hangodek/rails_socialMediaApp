class HomepagesController < ApplicationController
  allow_unauthenticated_access

  def index
    @user = Current.user
  end
end
