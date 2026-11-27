class User < ApplicationRecord
  GUEST_EMAIL = "guest@example.com".freeze

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy

  normalizes :email_address,
             with: ->(email) { email.strip.downcase }

  validates :name, presence: true

  validates :email_address,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :email_address,
            exclusion: {
              in: [ GUEST_EMAIL ],
              message: "はゲスト専用のため使用できません"
            },
            unless: :guest?

  validates :password,
            length: { minimum: 8 },
            allow_nil: true

  validates :password_confirmation,
            presence: true,
            on: :create

  def self.guest_account
    find_or_create_by!(email_address: GUEST_EMAIL, guest: true) do |user|
      user.name = "ゲストユーザー"
      user.password = SecureRandom.hex(16)
      user.password_confirmation = user.password
    end
  end
end
