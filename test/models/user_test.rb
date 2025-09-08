require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user does not prevent very long passwords" do
    users(:david).update(password: "secret" * 50)
    assert users(:david).valid?
  end

  test "validates email presence" do
    user = User.new(name: "Test User", password: "secret123456")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "validates email uniqueness" do
    existing_user = users(:david)
    new_user = User.new(name: "New User", email: existing_user.email, password: "secret123456")
    assert_not new_user.valid?
    assert_includes new_user.errors[:email], "has already been taken"
  end

  test "validates name presence" do
    user = User.new(email: "test@example.com", password: "secret123456")
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "active scope returns only active users" do
    users(:david).update!(active: true)
    users(:jason).update!(active: false)

    active_users = User.active
    assert_includes active_users, users(:david)
    assert_not_includes active_users, users(:jason)
  end

  test "without_bots scope excludes bot users" do
    users(:david).update!(role: :user)
    users(:jason).update!(role: :bot)

    non_bot_users = User.without_bots
    assert_includes non_bot_users, users(:david)
    assert_not_includes non_bot_users, users(:jason)
  end

  test "active_bots scope returns only active bots" do
    users(:david).update!(role: :bot, active: true)
    users(:jason).update!(role: :bot, active: false)
    users(:sam).update!(role: :user, active: true)

    active_bots = User.active_bots
    assert_includes active_bots, users(:david)
    assert_not_includes active_bots, users(:jason)
    assert_not_includes active_bots, users(:sam)
  end

  test "password authentication works" do
    user = users(:david)
    assert user.authenticate("secret123456")
    assert_not user.authenticate("wrong_password")
  end

  test "destroys associated sessions when user is destroyed" do
    user = users(:david)
    initial_session_count = user.sessions.count

    assert_difference "Session.count", -initial_session_count do
      user.destroy!
    end
  end

  private

  def create_new_user
    User.create!(name: "User", email: "user@example.com", password: "secret123456")
  end
end
