class AddOverworkStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overwork_status, :integer, default: 0, null: false
  end
end
