class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string :firstname
      t.string :lastname
      t.string :street
      t.string :zip
      t.string :city
      t.string :phone
      t.string :mobile
      t.string :email

      t.timestamps
    end
  end
end
