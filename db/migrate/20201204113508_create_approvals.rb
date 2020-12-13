class CreateApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :approvals do |t|
      t.integer :superior_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
