# frozen_string_literal: true

module LoginHelper
  def login_user(user = nil)
    user ||= FactoryBot.create(:user)
    post '/login', params: { login: { email: user.email, password: user.password } }
  end
end
