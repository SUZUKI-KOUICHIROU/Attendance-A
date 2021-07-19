class AddDateNoteToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :date_note, :string
  end
end
