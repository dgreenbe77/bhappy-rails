class RenameInfosTableToHappinessLogsTable < ActiveRecord::Migration
  def change
    rename_table :infos, :happiness_logs
  end
end
