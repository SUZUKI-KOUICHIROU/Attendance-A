class RemoveAddChangeStartedAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :change_started_at, :datetime
  end
end
