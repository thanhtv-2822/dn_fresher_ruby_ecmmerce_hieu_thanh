class Contribute < ApplicationRecord
  belongs_to :user
  validates :content, length: {maximum: Settings.length.len_200}
end
