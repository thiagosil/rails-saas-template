class User < ApplicationRecord
  has_many :sessions, dependent: :destroy

  has_secure_password validations: false

  scope :active, -> { where(active: true) }
  scope :active_bots, -> { active.where(role: :bot) }
  scope :without_bots, -> { where.not(role: :bot) }

  enum :role, { user: 0, bot: 1 }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def self.authenticate_bot(bot_key)
    bot_id, bot_token = bot_key.split("-")
    active.find_by(id: bot_id, bot_token: bot_token)
  end

  def self.generate_bot_token
    SecureRandom.alphanumeric(12)
  end

  def self.create_bot!(attributes)
    bot_token = generate_bot_token
    User.create!(**attributes, bot_token: bot_token, role: :bot)
  end

  def bot_key
    "#{id}-#{bot_token}"
  end

  def reset_bot_key
    update! bot_token: self.class.generate_bot_token
  end
end
