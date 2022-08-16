# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :current_user

  before_action :require_login

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    redirect_to login_path unless session.include? :user_id
  end
end
