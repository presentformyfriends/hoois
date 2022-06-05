class Query < ApplicationRecord
  validates :lookup, presence: true, length: { maximum: 255,
    too_long "%{count} characters maximum" }
end
