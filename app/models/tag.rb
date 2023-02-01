class Tag < ApplicationRecord
  belongs_to :user
  # name属性不能为空

  validates :name, presence: true
  validates :sign, presence: true
end
