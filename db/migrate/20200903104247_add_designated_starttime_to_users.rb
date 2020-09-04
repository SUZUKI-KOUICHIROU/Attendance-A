class AddDesignatedStarttimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :designated_starttime, :datetime, default: Time.current.change(hour: 9, min: 0, sec: 0)
  end
end
