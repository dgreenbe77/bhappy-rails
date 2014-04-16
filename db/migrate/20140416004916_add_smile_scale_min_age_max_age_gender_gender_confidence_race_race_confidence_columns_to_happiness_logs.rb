class AddSmileScaleMinAgeMaxAgeGenderGenderConfidenceRaceRaceConfidenceColumnsToHappinessLogs < ActiveRecord::Migration
  def change
    add_column :happiness_logs, :min_age, :integer
    add_column :happiness_logs, :max_age, :integer
    add_column :happiness_logs, :gender, :string
    add_column :happiness_logs, :gender_confidence, :float
    add_column :happiness_logs, :race, :string
    add_column :happiness_logs, :race_confidence, :float
    add_column :happiness_logs, :smile_scale, :float    
  end
end
