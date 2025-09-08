require "test_helper"

class User::BotTest < ActiveSupport::TestCase
  test "create bot generates token and sets role" do
    token = "5M0aLYwQyBXOXa5Wsz6NZb11EE4tW2"
    SecureRandom.stubs(:alphanumeric).with(12).returns(token)

    bot = User.create_bot!(name: "Bender", email: "bender@example.com")

    assert_equal "bot", bot.role
    assert_equal token, bot.bot_token
    assert_equal "#{bot.id}-#{token}", bot.bot_key
  end

  test "bot key format is id-token" do
    bot = users(:bot)
    expected_key = "#{bot.id}-#{bot.bot_token}"
    assert_equal expected_key, bot.bot_key
  end

  test "reset bot key generates new token" do
    bot = users(:bot)
    original_token = bot.bot_token

    new_token = "R4kme9anwWRuz3sSoBXiB8Li8ioZPP"
    SecureRandom.stubs(:alphanumeric).with(12).returns(new_token)

    bot.reset_bot_key

    assert_equal new_token, bot.reload.bot_token
    assert_not_equal original_token, bot.bot_token
  end

  test "authenticate_bot with valid key returns bot user" do
    bot = users(:bot)
    authenticated_bot = User.authenticate_bot(bot.bot_key)

    assert_equal bot, authenticated_bot
  end

  test "authenticate_bot with invalid key returns nil" do
    invalid_key = "999-invalidtoken"
    authenticated_bot = User.authenticate_bot(invalid_key)

    assert_nil authenticated_bot
  end

  test "authenticate_bot with inactive bot returns nil" do
    bot = users(:bot)
    bot.update!(active: false)

    authenticated_bot = User.authenticate_bot(bot.bot_key)

    assert_nil authenticated_bot
  end

  test "authenticate_bot with malformed key returns nil" do
    malformed_keys = [
      "invalidkey",
      "123",
      "123-",
      "-token",
      ""
    ]

    malformed_keys.each do |key|
      assert_nil User.authenticate_bot(key), "Expected nil for key: #{key}"
    end
  end

  test "generate_bot_token returns 12 character alphanumeric string" do
    token = User.generate_bot_token

    assert_equal 12, token.length
    assert_match /\A[a-zA-Z0-9]{12}\z/, token
  end
end
