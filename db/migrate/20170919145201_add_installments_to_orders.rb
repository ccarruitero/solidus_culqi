# frozen_string_literal: true

class AddInstallmentsToOrders < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_orders, :installments, :integer
  end
end
