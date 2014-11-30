class CreateRejectedInterviewBlocks < ActiveRecord::Migration
  def change
    create_table :rejected_interview_blocks do |t|
      t.references :interview, index: true
      t.datetime :start_time
      t.datetime :end_time
    end
  end
end
