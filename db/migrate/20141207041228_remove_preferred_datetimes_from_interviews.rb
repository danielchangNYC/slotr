class RemovePreferredDatetimesFromInterviews < ActiveRecord::Migration
  def change
    remove_column :interviews, :preferred_datetime_top
    remove_column :interviews, :preferred_datetime_middle
    remove_column :interviews, :preferred_datetime_bottom
  end
end
