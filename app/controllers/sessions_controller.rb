class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    render layout: "session"
  end

  def create
    omni_auth_info = request.env["omniauth.auth"]

    if omni_auth_info
      user = User.authenticate_by_omni_auth(omni_auth_info)
      start_new_session_for user
      redirect_to after_authentication_url
    elsif omni_auth_info.nil?
      user = User.authenticate_by(params.permit(:username, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      render :new, layout: "session", status: :unprocessable_entity, alert: user.errors.full_messages.to_sentence
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
