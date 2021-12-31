class AddApprovalNextToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :approval_next, :boolean, default: false, null: false
  end
end
