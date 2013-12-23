class ChangeColumnNameForGuestsInReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :guests, :adults
  end
end
