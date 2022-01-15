class AddAttendanceCheckToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_check, :integer, default: 0
  end
end
