class AddSuperiorSetToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :superior_set, :string
  end
end
