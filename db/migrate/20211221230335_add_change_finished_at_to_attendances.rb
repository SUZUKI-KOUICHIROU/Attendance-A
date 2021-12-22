class AddChangeFinishedAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_finished_at, :datetime, default: "1900-01-01 01:00:00"
  end
end
