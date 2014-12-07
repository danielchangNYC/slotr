class RemovePreferredBlocks < ActiveRecord::Migration
  def change
    remove_column :schedule_responses, :preferred_block1
    remove_column :schedule_responses, :preferred_block2
    remove_column :schedule_responses, :preferred_block3
    remove_column :interviews, :preferred_block1
    remove_column :interviews, :preferred_block2
    remove_column :interviews, :preferred_block3
  end
end
