class AddRankToRankings < ActiveRecord::Migration
  def change
    add_column :rankings, :rank, :integer
  end
end
