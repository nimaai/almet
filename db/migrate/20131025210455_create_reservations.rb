class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.date :arrival
      t.date :departure
      t.integer :guests
      t.belongs_to :visitor

      t.timestamps
    end
  end
end
