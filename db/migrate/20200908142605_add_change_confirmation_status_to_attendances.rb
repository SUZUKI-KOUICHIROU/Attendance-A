class AddChangeConfirmationStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_confirmation_status, :string
  end
end
