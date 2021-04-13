class AddBusinessContentsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :business_contents, :string
  end
end
