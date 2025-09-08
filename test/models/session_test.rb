require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "belongs to user" do
    session = sessions(:david_session)
    assert_equal users(:david), session.user
  end

  test "has secure token generated automatically" do
    session = Session.new(user: users(:david), user_agent: "Test Browser", ip_address: "127.0.0.1")
    session.save!

    assert_not_nil session.token
    assert_equal 24, session.token.length # has_secure_token generates 24 character token
  end

  test "sets last_active_at before create" do
    freeze_time = Time.zone.parse("2023-01-01 12:00:00")

    Time.stubs(:now).returns(freeze_time)
    session = Session.create!(user: users(:david), user_agent: "Test Browser", ip_address: "127.0.0.1")
    assert_equal freeze_time, session.last_active_at
  end

  test "start! creates session with user_agent and ip_address" do
    user = users(:david)
    user_agent = "Mozilla/5.0 Test Browser"
    ip_address = "192.168.1.1"

    session = user.sessions.start!(user_agent: user_agent, ip_address: ip_address)

    assert session.persisted?
    assert_equal user_agent, session.user_agent
    assert_equal ip_address, session.ip_address
    assert_not_nil session.last_active_at
  end

  test "resume updates session when last active is stale" do
    session = sessions(:david_session)
    old_time = 2.hours.ago
    session.update!(last_active_at: old_time)

    new_user_agent = "Updated Browser"
    new_ip_address = "10.0.0.1"

    session.resume(user_agent: new_user_agent, ip_address: new_ip_address)
    session.reload

    assert_equal new_user_agent, session.user_agent
    assert_equal new_ip_address, session.ip_address
    assert session.last_active_at > old_time
  end

  test "resume does not update when last active is recent" do
    session = sessions(:david_session)
    recent_time = 30.minutes.ago
    original_user_agent = session.user_agent
    original_ip_address = session.ip_address

    session.update!(last_active_at: recent_time)

    session.resume(user_agent: "New Browser", ip_address: "10.0.0.1")
    session.reload

    assert_equal original_user_agent, session.user_agent
    assert_equal original_ip_address, session.ip_address
    assert_equal recent_time.to_i, session.last_active_at.to_i
  end

  test "activity refresh rate constant" do
    assert_equal 1.hour, Session::ACTIVITY_REFRESH_RATE
  end
end
