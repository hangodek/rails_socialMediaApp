class RegistersController < ApplicationController
  allow_unauthenticated_access
  def new
    @user = User.new
    render layout: "session"
  end

  def create
    @user = User.new(register_new_user_params)

    if @user.save
      redirect_to new_session_path, notice: "User created successfully. Please log in."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity, layout: "session"
    end
  end

  private

  def register_new_user_params
    params.expect(user: [ :username, :email_address, :email_confirmation, :password ])
  end
end
