class Contribute < ApplicationRecord
  belongs_to :user
  validates :content, length: {maximum: Settings.length.len_200}
  has_one_attached :image
  before_save :current_status
  enum status: {pending: 0, accept: 1}

  CONT_ATT = %w(content image).freeze

  private
  def current_status
    self.status = 0
  end
end
