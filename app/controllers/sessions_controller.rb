class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    render layout: "session"
  end

  def create
    omni_auth_info = request.env["omniauth.auth"]
    Rails.logger.info omni_auth_info

    if omni_auth_info
      user = User.authenticate_by_omni_auth(omni_auth_info)

      if user
        start_new_session_for user
        redirect_to after_authentication_url
      else
        flash.now[:alert] = "OmniAuth authentication failed."
        render :new, layout: "session", status: :unprocessable_entity
      end
    elsif omni_auth_info.nil?
      user = User.authenticate_by(params.permit(:username, :password))

      if user
        start_new_session_for user
        redirect_to after_authentication_url
      else
        flash.now[:alert] = "Invalid username or password."
        render :new, layout: "session", status: :unprocessable_entity
      end
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
