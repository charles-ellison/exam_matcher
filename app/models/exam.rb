class Exam < ApplicationRecord
  belongs_to :college
  validates_presence_of :college_id
end
