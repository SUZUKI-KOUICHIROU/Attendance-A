class AddDateFormToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :date_form, :date
  end
end
