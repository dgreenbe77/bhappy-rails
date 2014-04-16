class AddQuestionColumnToHappinessLogs < ActiveRecord::Migration
  def change
    add_column :happiness_logs, :question, :string
  end
end
