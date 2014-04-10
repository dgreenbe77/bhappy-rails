class AddColumnHappyToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :happy, :integer, default: 0
  end
end
