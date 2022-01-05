class AddBeforeStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :before_status, :string
  end
end
