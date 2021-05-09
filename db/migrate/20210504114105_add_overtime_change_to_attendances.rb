class AddOvertimeChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_change, :boolean, default: false, null: false
  end
end
