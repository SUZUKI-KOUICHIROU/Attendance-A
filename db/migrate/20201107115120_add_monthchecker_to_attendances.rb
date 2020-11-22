class AddMonthcheckerToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_checker, :string
  end
end
