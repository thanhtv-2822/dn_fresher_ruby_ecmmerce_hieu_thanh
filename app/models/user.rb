class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :contributes, dependent: :destroy
  has_many :orders, dependent: :destroy
  before_save{self.email = email.downcase}
  validates :email, uniqueness: true,
   length: {maximum: Settings.length.len_50},
   format: {with: Settings.regex.email}
  validates :password, length:
   {in: Range.new(Settings.length.len_6, Settings.length.len_50)}
  validates :name, length: {maximum: Settings.length.len_50}

  has_secure_password
end
