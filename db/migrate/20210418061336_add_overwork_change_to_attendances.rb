class AddOverworkChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overwork_change, :boolean, default: false, null: false
  end
end
