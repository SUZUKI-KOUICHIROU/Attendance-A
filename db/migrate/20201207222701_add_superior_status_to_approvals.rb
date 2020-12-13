class AddSuperiorStatusToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :superior_status, :string
  end
end
