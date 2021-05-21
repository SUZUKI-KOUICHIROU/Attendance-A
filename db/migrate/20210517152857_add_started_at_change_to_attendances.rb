class AddStartedAtChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :started_at_change, :datetime
  end
end
