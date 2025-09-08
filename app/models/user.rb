class User < ApplicationRecord
  has_many :sessions, dependent: :destroy

  has_secure_password validations: false

  scope :active, -> { where(active: true) }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
