class UserExam < ApplicationRecord
  belongs_to :user
  belongs_to :exam

  validates_uniqueness_of :user_id, scope: :exam_id
end
