class DropPaymentsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :payments
  end
end