class RemoveRankFromPossibleInterviewBlocks < ActiveRecord::Migration
  def change
    remove_column :possible_interview_blocks, :rank
  end
end
