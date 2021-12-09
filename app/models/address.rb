class Address < ApplicationRecord
  # phone must be a interger and 11 characters
  validates :phone, length: {is: Settings.length.len_11},
            numericality: {only_integer: true}
  validates :street, :commune, :district, :city,
            length: {maximum: Settings.length.len_20}
end
