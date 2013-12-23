class AddColumnsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :children, :integer
    add_column :reservations, :bedclothes_service, :boolean
  end
end
