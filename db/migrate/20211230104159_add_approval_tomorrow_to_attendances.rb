class AddApprovalTomorrowToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :approval_tomorrow, :boolean, default: false, null: false
  end
end
