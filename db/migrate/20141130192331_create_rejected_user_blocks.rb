class CreateRejectedUserBlocks < ActiveRecord::Migration
  def change
    create_table :rejected_user_blocks do |t|
      t.references :user, index: true
      t.datetime :start_time
      t.datetime :end_time
    end
  end
end
