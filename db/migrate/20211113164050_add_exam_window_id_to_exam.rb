class AddExamWindowIdToExam < ActiveRecord::Migration[6.0]
  def change
    add_column :exams, :exam_window_id, :integer
    remove_column :exams, :start_window, :datetime
    remove_column :exams, :end_window, :datetime
  end
end
