class AddApprovalContentsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :approval_contents, :string
  end
end
