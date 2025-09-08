require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "new renders login form" do
    get new_session_url
    assert_response :success
    assert_select "form"
  end

  test "create with valid credentials signs in user" do
    user = users(:david)

    post sessions_url, params: { email: user.email, password: "secret123456" }

    assert_redirected_to root_url
    assert parsed_cookies.signed[:session_token]
    follow_redirect!
    assert_select ".notice", text: "Signed in successfully"
  end

  test "create with invalid email returns error" do
    post sessions_url, params: { email: "nonexistent@example.com", password: "secret123456" }

    assert_response :unprocessable_entity
    assert_nil parsed_cookies.signed[:session_token]
    assert_select ".alert", text: "Try another email address or password."
  end

  test "create with invalid password returns error" do
    user = users(:david)

    post sessions_url, params: { email: user.email, password: "wrongpassword" }

    assert_response :unprocessable_entity
    assert_nil parsed_cookies.signed[:session_token]
    assert_select ".alert", text: "Try another email address or password."
  end

  test "create with valid credentials creates new session" do
    user = users(:david)

    assert_difference "user.sessions.count", 1 do
      post sessions_url, params: { email: user.email, password: "secret123456" }
    end

    assert_redirected_to root_url
  end

  test "create redirects to return_to_after_authenticating when set" do
    session[:return_to_after_authenticating] = "/dashboard"
    user = users(:david)

    post sessions_url, params: { email: user.email, password: "secret123456" }

    assert_redirected_to "/dashboard"
  end

  test "destroy signs out user and clears session" do
    sign_in :david
    session_id = parsed_cookies.signed[:session_token]

    delete session_url(sessions(:david_session))

    assert_redirected_to root_url
    assert_not cookies[:session_token].present?
    follow_redirect!
    assert_select ".notice", text: "Signed out successfully"
  end

  test "destroy removes session from database" do
    sign_in :david
    session = sessions(:david_session)

    assert_difference "Session.count", -1 do
      delete session_url(session)
    end
  end

  test "destroy requires authentication" do
    delete session_url(999) # Non-existent session ID

    assert_redirected_to new_session_path
  end

  test "destroy only allows user to delete their own sessions" do
    sign_in :david
    other_user_session = sessions(:jason_session)

    assert_raises ActiveRecord::RecordNotFound do
      delete session_url(other_user_session)
    end
  end

  test "new and create allow unauthenticated access" do
    # These should not redirect to login
    get new_session_url
    assert_response :success

    post sessions_url, params: { email: "test@example.com", password: "wrong" }
    assert_response :unprocessable_entity
  end

  private

  def parsed_cookies
    ActionDispatch::Cookies::CookieJar.build(@request, @response.cookies)
  end
end
