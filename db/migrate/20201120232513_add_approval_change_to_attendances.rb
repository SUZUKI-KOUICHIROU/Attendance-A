class AddApprovalChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :approval_change, :string
  end
end
