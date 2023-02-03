class Item < ApplicationRecord
  enum kind: { expense: 1, income: 0 }

  validates :amount, presence: true
  validates :happen_at, presence: true

  validate :tags_id, :tags_belong_current_user

  def tags_belong_current_user
    #     all_uer_tag_ids = Tag.where(user_id: self.user_id).map do |i| i.id end
    # 可以用下面的方法简化
    all_user_tag_ids = Tag.where(user_id: self.user_id).map(&:id)
    if self.tags_id & all_user_tag_ids != self.tags_id
      self.errors.add :tags_id, "标签不属于当前用户"
    end unless self.tags_id.nil?
  end
end
