class Address < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy
  # phone must be a interger and 11 characters
  validates :phone, length: {is: Settings.length.len_11},
            numericality: {only_integer: true}
  validates :street, :commune, :district, :city,
            length: {maximum: Settings.length.len_20}
  ADD_ATTRS = %w(phone street commune district city default).freeze
  def address_initial
    "#{phone}, #{commune}, #{street}, #{district}, #{city}"
  end
end
