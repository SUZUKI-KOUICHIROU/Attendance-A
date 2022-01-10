class AddApprovalStartedToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :approval_started, :datetime
  end
end
