class Payment < ApplicationRecord
  validates :name, length: {maximum: Settings.length.len_20}
end
