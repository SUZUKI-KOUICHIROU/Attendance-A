class AddSuperiorConfirmationToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :superior_confirmation, :string
  end
end
