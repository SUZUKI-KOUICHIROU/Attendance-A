class AddWorktimeApprovalToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :worktime_approval, :integer, default: 0, null: false
  end
end
