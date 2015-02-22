class AddColumnsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :children, :integer, null: false
    add_column :reservations, :bedclothes_service, :boolean, null: false
  end
end
