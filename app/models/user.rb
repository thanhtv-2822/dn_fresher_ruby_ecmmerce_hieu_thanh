class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :contributes, dependent: :destroy
  has_many :orders, dependent: :destroy
  before_save{self.email = email.downcase}
  validates :email, uniqueness: true,
   length: {maximum: Settings.length.len_50},
   format: {with: Settings.regex.email}
  validates :password, presence: true, allow_nil: true,
  length: {in: Range.new(Settings.length.len_6, Settings.length.len_50)}
  validates :name, presence: true, length: {maximum: Settings.length.len_50}
  USER_ATTRS = %w(name email password password_confirmation).freeze

  has_secure_password

end
