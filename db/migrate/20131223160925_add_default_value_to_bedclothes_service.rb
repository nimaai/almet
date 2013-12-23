class AddDefaultValueToBedclothesService < ActiveRecord::Migration
  def change
    change_table :reservations do |t|
      t.change :bedclothes_service, :boolean, default: true
    end
  end
end
