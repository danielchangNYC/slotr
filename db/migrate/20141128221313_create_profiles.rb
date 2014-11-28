class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.belongs_to :user
      t.time :preferred_ends_at
      t.time :preferred_begins_at
      t.boolean :prefer_mon
      t.boolean :prefer_tues
      t.boolean :prefer_wed
      t.boolean :prefer_thurs
      t.boolean :prefer_fri
      t.boolean :prefer_sat
      t.boolean :prefer_sun
    end
  end
end
