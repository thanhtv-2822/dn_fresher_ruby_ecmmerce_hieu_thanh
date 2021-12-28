class Contribute < ApplicationRecord
  belongs_to :user
  validates :content, presence: true,
   length: {maximum: Settings.length.len_200}
  has_one_attached :image
  enum status: {pending: 0, accept: 1}

  scope :filter_accept, ->{where(status: 1)}
  scope :filter_pending, ->{where(status: 0)}

  CONT_ATT = %w(content image).freeze
end
