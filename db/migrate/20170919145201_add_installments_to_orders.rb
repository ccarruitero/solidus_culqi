class AddInstallmentsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_orders, :installments, :integer
  end
end
