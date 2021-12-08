class AddChangeStartedAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_started_at, :datetime
  end
end
