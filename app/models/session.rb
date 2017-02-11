class Session < ApplicationRecord
  validates :title, presence: true
end
