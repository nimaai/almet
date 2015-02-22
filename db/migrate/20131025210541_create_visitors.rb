class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      # TODO: not null constraints
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :street, null: false
      t.string :zip, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.string :phone
      t.string :mobile
      t.string :email, null: false

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        execute 'ALTER TABLE visitors ' \
                'ADD CONSTRAINT either_phone_or_mobile_must_be_set ' \
                'CHECK (phone IS NOT NULL OR mobile IS NOT NULL);'
      end
    end

    reversible do |dir|
      dir.up do
        execute \
          'ALTER TABLE visitors ALTER COLUMN created_at SET DEFAULT now()'
        execute \
          'ALTER TABLE visitors ALTER COLUMN updated_at SET DEFAULT now()'
      end
    end
  end
end
