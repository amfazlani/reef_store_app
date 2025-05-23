class AddPlaceIdToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :place_id, :string
  end
end
