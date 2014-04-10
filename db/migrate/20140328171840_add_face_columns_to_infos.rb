class AddFaceColumnsToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :smile, :float
  end
end
