class AddPreferredInterviewBlocksToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :preferred_block1, :integer
    add_column :interviews, :preferred_block2, :integer
    add_column :interviews, :preferred_block3, :integer
  end
end
