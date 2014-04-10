class AddScaleColumnsToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :positive_scale, :float
    add_column :infos, :negative_scale, :float
    add_column :infos, :happy_scale, :float
    add_column :infos, :health_scale, :float
    add_column :infos, :wealth_scale, :float
    add_column :infos, :culture_scale, :float
    add_column :infos, :location_scale, :float
    add_column :infos, :spirituality_scale, :float
    add_column :infos, :relationship_scale, :float
    add_column :infos, :activity_scale, :float
    add_column :infos, :passion_scale, :float
    add_column :infos, :satisfaction_scale, :float
    add_column :infos, :self_view_scale, :float  
  end
end
