class Contribute < ApplicationRecord
  belongs_to :user
  validates :content, length: {maximum: Settings.length.len_200}
  enum status: {pending: 0, accept: 1}

  scope :filter_accept, ->{where(status: 1)}
  scope :filter_pending, ->{where(status: 0)}

  CONT_ATT = %w(content image).freeze
end
