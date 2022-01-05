class AddBeforeSuperiorToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :before_superior, :string
  end
end
