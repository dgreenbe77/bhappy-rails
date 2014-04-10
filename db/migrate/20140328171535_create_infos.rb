class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.float :health, default: 0
      t.float :wealth, default: 0
      t.float :culture, default: 0
      t.float :location, default: 0
      t.float :spirituality, default: 0
      t.float :relationship, default: 0
      t.float :activity, default: 0
      t.float :passion, default: 0
      t.float :satisfaction, default: 0
      t.float :self_view, default: 0
      t.integer :user_id

      t.timestamps
    end
  end
end
