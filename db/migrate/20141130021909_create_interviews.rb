class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.references :scheduler, index: true
      t.references :interviewee, index: true
      t.datetime :preferred_datetime_top
      t.datetime :preferred_datetime_middle
      t.datetime :preferred_datetime_bottom
      t.datetime :begins_at
      t.datetime :ends_at
      t.timestamps
    end
  end
end
