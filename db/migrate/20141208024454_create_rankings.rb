class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.references :user, index: true
      t.references :possible_interview_block, index: true
    end
  end
end
