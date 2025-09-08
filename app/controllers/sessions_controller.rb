class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render_rejection :too_many_requests }

  def new
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      start_new_session_for user
      redirect_to post_authenticating_url
    else
      render_rejection :unauthorized
    end
  end

  def destroy
    reset_authentication
    redirect_to root_path
  end

  private
    def render_rejection(status)
      flash.now[:alert] = "Invalid email or password."
      render :new, status: status
    end
end
