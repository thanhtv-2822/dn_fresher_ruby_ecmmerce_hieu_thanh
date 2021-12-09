class Address < ApplicationRecord
  has_many :orders, dependent: :destroy
  belongs_to :user
  validates :phone, length: {is: Settings.length.len_11},
            numericality: {only_integer: true}
  validates :street, :commune, :district, :city,
            length: {maximum: Settings.length.len_20}
  validate :check_default, if: ->{:default.present?}
  ADD_ATTRS = %w(phone street commune district city default).freeze
  def address_initial
    "#{phone}, #{commune}, #{street}, #{district}, #{city}"
  end

  private

  def check_default
    if self.default != 1 && default == 1 && Address.find_by(default: 1)
      errors.add(:default, I18n.t("errors.default"))
    end
  end
end
