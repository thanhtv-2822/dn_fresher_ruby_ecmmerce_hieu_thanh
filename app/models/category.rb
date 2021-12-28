class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  validates :name, presence: true, length: {maximum: Settings.length.len_200}

  scope :filter_by_parent_id, ->{where(parent_id: nil)}
  scope :filter_cate_child, ->{where.not(parent_id: nil)}

  CATE_ATTRS = %w(name parent_id).freeze
end
