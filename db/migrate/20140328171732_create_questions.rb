class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :main_postq, null: false

      t.timestamps
    end
  end
end
