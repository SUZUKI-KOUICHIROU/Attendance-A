class AddDesignatedEndtimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :designated_endtime, :datetime, default: Time.current.change(hour: 18, min: 0, sec: 0)
  end
end
