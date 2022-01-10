class AddWorktimeBeforeApprovalToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :worktime_before_approval, :string
  end
end
