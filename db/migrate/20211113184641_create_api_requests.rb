class CreateApiRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :api_requests do |t|
      t.string :status
      t.string :message
      t.integer :exam_id
      t.timestamps
    end
  end
end
