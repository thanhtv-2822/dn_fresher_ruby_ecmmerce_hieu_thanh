class Contribute < ApplicationRecord
  validates :content, length: {maximum: Settings.length.len_200}
end
