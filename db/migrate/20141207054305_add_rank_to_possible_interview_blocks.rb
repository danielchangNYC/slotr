class AddRankToPossibleInterviewBlocks < ActiveRecord::Migration
  def change
    add_column :possible_interview_blocks, :rank, :integer
  end
end
