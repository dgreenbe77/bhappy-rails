class AddPositiveqAndNegativeqColumnsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :positiveq, :string, null: false
    add_index :questions, :positiveq, unique: true
    add_column :questions, :negativeq, :string, null: false
    add_index :questions, :negativeq, unique: true
    remove_column :questions, :main_postq
  end
end
