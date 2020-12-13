class AddMonthCheckerToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :month_checker, :string
  end
end
