module SessionTestHelper
  def parsed_cookies
    ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)
  end

  def sign_in(user)
    user = users(user) unless user.is_a? User
    post session_url, params: { email: user.email, password: "secret123456" }
    assert cookies[:session_token].present?, "Expected session_token cookie to be set after sign in"
  end

  def sign_out
    delete session_url if current_session
    assert_not cookies[:session_token].present?, "Expected session_token cookie to be cleared after sign out"
  end

  def current_session
    return nil unless cookies[:session_token]

    token = parsed_cookies.signed[:session_token]
    Session.find_by(token: token)
  end

  def current_user
    current_session&.user
  end

  def assert_requires_authentication
    assert_redirected_to new_session_path, "Expected redirect to login page for unauthenticated request"
  end

  def assert_signed_in_as(expected_user)
    expected_user = users(expected_user) unless expected_user.is_a? User
    assert_equal expected_user, current_user, "Expected to be signed in as #{expected_user.name}"
  end

  def assert_not_signed_in
    assert_nil current_user, "Expected not to be signed in"
  end
end
