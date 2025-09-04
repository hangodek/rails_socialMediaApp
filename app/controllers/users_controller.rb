class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(rich_text_content: [ :embeds_attachments ]).order(created_at: :desc)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found"
  end

  def edit
    @user = User.find(Current.user.id)
  end

  def update
    @user = Current.user

    if params[:user][:avatar].present?
      @user.avatar.attach(params[:user][:avatar])
    end

    if @user.update(user_information_params)
      redirect_to edit_user_path, notice: "User updated successfully."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def edit_bio
    @user = User.find(params.expect(:id))

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update_bio
    @user = User.find(params.expect(:id))

    if @user.update(params.expect(user: [ :bio ]))
      respond_to do |format|
        format.turbo_stream
      end
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user = Current.user

    if current_user == @user
      redirect_to user_path(@user), alert: "You cannot follow yourself"
      return
    end

    unless current_user.followings.include?(@user)
      current_user.active_follows.create(following: @user)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(@user) }
    end
  end

  def unfollow
    @user = User.find(params[:id])
    current_user = Current.user

    follow = current_user.active_follows.find_by(following: @user)
    follow&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(@user) }
    end
  end

  private

  def user_information_params
    params.expect(user: [ :username, :email_address, :password ])
  end
end
