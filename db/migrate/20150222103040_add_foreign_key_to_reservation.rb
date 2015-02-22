class AddForeignKeyToReservation < ActiveRecord::Migration
  def change
    add_foreign_key :reservations, :visitors
  end
end
