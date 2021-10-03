class CreateAttendancelogs < ActiveRecord::Migration[5.1]
  def change
    create_table :attendancelogs do |t|
      t.date :month_form

      t.timestamps
    end
  end
end
