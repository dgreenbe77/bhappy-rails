class AddAddressToInfo < ActiveRecord::Migration
  def change
    add_column :infos, :address, :string, null: false
  end
end
