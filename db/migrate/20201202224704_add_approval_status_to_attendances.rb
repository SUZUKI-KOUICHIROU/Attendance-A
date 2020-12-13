class AddApprovalStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :approval_status, :integer
  end
end
