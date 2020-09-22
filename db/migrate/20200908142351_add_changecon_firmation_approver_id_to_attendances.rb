class AddChangeconFirmationApproverIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_confirmation_approver_id, :string
  end
end
