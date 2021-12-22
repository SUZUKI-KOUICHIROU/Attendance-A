class AddBeforeNoteToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :before_note, :string
  end
end
