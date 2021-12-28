class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :contributes, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one_attached :image
  scope :order_by_updated_at, ->{order(created_at: "DESC")}
  scope :filter_by_name, ->(q){where "name LIKE ?", "%#{q}%"}
  before_save{self.email = email.downcase}

  validates :email, uniqueness: true,
   length: {maximum: Settings.length.len_50},
   format: {with: Settings.regex.email}
  validates :password, presence: true, allow_nil: true,
  length: {in: Range.new(Settings.length.len_6, Settings.length.len_50)}
  validates :name, presence: true, length: {maximum: Settings.length.len_50}
  validates :image, content_type:
  {in: %w(image/jpeg image/gif image/png),
   message: "must be a valid image format"},
  size: {less_than: 5.megabytes,
         message: "should be less than 5MB"}
  USER_ATTRS = %w(name email password password_confirmation).freeze
  UPLOAD = %w(image).freeze
  has_secure_password

  def display_image
    image.variant(resize_to_limit: [250, 250])
  end
end
