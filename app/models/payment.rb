class Payment < ApplicationRecord
  has_many :orders, dependent: :destroy
  validates :name, length: {maximum: Settings.length.len_200}
end
