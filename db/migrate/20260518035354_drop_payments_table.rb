class DropPaymentsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :payments, if_exists: true
  end
end