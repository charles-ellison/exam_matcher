class CreateExams < ActiveRecord::Migration[6.0]
  def change
    create_table :exams do |t|
      t.integer :college_id
      t.datetime :start_window
      t.datetime :end_window
      t.timestamps
    end
  end
end
