class AddColumnsToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :main_post, :text, null: false
    add_column :infos, :positive, :float, default: 0
    add_column :infos, :negative, :float, default: 0
    add_column :infos, :why_post, :text
  end
end
