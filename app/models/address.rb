class Address < ApplicationRecord
  has_many :orders, dependent: :destroy
  belongs_to :user
  validates :phone, length: {is: Settings.length.len_11},
            numericality: {only_integer: true}
  validates :street, :commune, :district, :city,
            length: {maximum: Settings.length.len_20}
end
