class CreateInterviewInterviewers < ActiveRecord::Migration
  def change
    create_table :interview_interviewers do |t|
      t.references :interview, index: true
      t.integer :interviewer_id
      t.references :interview, index: true
    end
  end
end
