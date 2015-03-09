class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.date :arrival, null: false
      t.date :departure, null: false
      t.integer :guests, null: false
      t.belongs_to :visitor, null: false

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        execute \
          'ALTER TABLE reservations ALTER COLUMN created_at SET DEFAULT now()'
        execute \
          'ALTER TABLE reservations ALTER COLUMN updated_at SET DEFAULT now()'
      end
    end
  end
end
