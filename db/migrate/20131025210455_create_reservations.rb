class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.date :start_date
      t.date :end_date
      t.belongs_to :user

      t.timestamps
    end
  end
end
