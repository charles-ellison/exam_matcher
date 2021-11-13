class CreateUserExams < ActiveRecord::Migration[6.0]
  def change
    create_table :user_exams do |t|
      t.integer :user_id
      t.integer :exam_id
      t.timestamps
    end
  end
end
