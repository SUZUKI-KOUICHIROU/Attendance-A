class AddWorktimeChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :worktime_change, :boolean, default: false, null: false
  end
end
