class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :set_session, only: %i[ show destroy ]

  def new
    @user = User.new
  end

  def create
    if @user = User.find_by(email: params[:email])
      if @user.authenticate(params[:password])
        @session = start_new_session_for(@user)
        redirect_to post_authenticating_url, notice: "Signed in successfully"
      else
        flash.now[:alert] = "Try another email address or password."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Try another email address or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @session.destroy
    reset_authentication
    redirect_to root_path, notice: "Signed out successfully"
  end

  private
    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
