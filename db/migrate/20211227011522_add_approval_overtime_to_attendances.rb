class AddApprovalOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :approval_overtime, :datetime
  end
end
