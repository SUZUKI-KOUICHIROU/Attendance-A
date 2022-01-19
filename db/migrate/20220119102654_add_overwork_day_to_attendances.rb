class AddOverworkDayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overwork_day, :date
  end
end
