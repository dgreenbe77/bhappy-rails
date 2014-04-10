class AddTitleColumnToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :title, :string, null: false
  end
end
