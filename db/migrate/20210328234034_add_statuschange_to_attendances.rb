class AddStatuschangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :status_change, :boolean, default: false, null: false
  end
end
