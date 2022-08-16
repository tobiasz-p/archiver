# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to :root
    else
      flash.now[:danger] = 'Nieprawidłowy email lub hasło'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Zostałeś wylogowany'
    redirect_to login_path
  end

  private

  def session_params
    params.require(:login).permit(:email, :password)
  end
end
