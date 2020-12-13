class AddStatusChangeToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :status_change, :string
  end
end
