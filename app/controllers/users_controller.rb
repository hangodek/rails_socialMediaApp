class UsersController < ApplicationController
  def show
    @user = User.includes(posts: [ :rich_text_content, :likes, :comments ]).find(params[:id])
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

  private

  def user_information_params
    params.expect(user: [ :username, :email_address, :password ])
  end
end
