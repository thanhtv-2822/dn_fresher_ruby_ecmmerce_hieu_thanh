class Payment < ApplicationRecord
  has_many :order, dependent: :destroy
  validates :name, length: {maximum: Settings.length.len_20}
end
