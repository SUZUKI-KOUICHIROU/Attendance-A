class AddWorktimeBeforeSuperiorToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :worktime_before_superior, :string
  end
end
