class CreateScheduleResponses < ActiveRecord::Migration
  def change
    create_table :schedule_responses do |t|
      t.references :interview, index: true
      t.references :user, index: true
      t.datetime :responded_on
      t.string :code
    end
  end
end
