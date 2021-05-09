class AddWorktimeStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :worktime_status, :string
  end
end
