class ChangeDefaultValuesForReservations < ActiveRecord::Migration
  def change
    change_table :reservations do |t|
      t.change :adults, :integer, default: 1
      t.change :children, :integer, default: 0
    end
  end
end
