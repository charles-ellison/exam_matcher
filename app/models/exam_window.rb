class ExamWindow < ApplicationRecord
  def valid_start_time?(test_time)
    start_time <= test_time && end_time >= test_time
  end
end
