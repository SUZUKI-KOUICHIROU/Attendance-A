class AddNextdayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next_day, :boolean, default: false, null: true
  end
end
