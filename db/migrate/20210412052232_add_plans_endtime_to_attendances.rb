class AddPlansEndtimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :plans_endtime, :datetime
  end
end
