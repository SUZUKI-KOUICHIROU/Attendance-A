class AddOverworkStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overwork_status, :string
  end
end
