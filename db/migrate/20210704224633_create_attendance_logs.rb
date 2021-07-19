class CreateAttendanceLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :attendance_logs do |t|
      t.date :date_select

      t.timestamps
    end
  end
end
