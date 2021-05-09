class AddWorktimeCheckSuperiorToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :worktime_check_superior, :string
  end
end
