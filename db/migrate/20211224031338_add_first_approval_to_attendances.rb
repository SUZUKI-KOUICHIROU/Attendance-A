class AddFirstApprovalToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :first_approval, :integer, default: 0
  end
end
