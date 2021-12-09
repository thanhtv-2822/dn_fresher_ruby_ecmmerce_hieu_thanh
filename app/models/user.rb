class User < ApplicationRecord
  validates :email, uniqueness: true,
   length: {maximum: Settings.length.len_50},
   format: {with: Settings.regex}
  validates :password, length:
   {in: Range.new(Settings.length.len_6, Settings.length.len_50)}
  validates :name, length: {maximum: Settings.length.len_20}

  has_secure_password
end
