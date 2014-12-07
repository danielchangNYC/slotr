class AddPreferredInterviewBlocksToScheduleResponses < ActiveRecord::Migration
  def change
    add_column :schedule_responses, :preferred_block1, :integer
    add_column :schedule_responses, :preferred_block2, :integer
    add_column :schedule_responses, :preferred_block3, :integer
  end
end
