class Item < ApplicationRecord
  validates :amount, presence: true
  validates :happen_at, presence: true

  enum kind: { expense: 1, income: 0 }
end
