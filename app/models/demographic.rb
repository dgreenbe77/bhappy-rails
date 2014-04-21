class Demographic

  def self.compare_age_ranges(min, max, min2, max2)
    age_range1 = HappinessLog.where("min_age >= #{min} AND max_age <= #{max}").pluck(:happy_scale).delete_if { |int| int.nil? }
    age_range2 = HappinessLog.where("min_age >= #{min2} AND max_age <= #{max2}").pluck(:happy_scale).delete_if { |int| int.nil? }
    compare_two_values_and_return_string(age_range1, age_range2, "People Between Ages #{min} and #{max} are Happier \n than People Between Ages #{min2} and #{max2}.",
      "People Between Ages #{min2} and #{max2} are Happier \n than People Between Ages #{min} and #{max}.")
  end

  def self.compare_genders
    male = HappinessLog.where("gender = 'Male' AND gender_confidence >= 60").pluck(:happy_scale).delete_if { |int| int.nil? }
    female = HappinessLog.where("gender = 'Female' AND gender_confidence >= 60").pluck(:happy_scale).delete_if { |int| int.nil? }
    compare_two_values_and_return_string(male, female,
      "Males are Happier than Females.", "Females are Happier than Males.")
  end

  def self.compare_smiles
    smiling = HappinessLog.where("smile >= 50").pluck(:happy_scale).delete_if { |int| int.nil? }
    frowning = HappinessLog.where("smile <= 50").pluck(:happy_scale).delete_if { |int| int.nil? }
    compare_two_values_and_return_string(smiling, frowning, "People who Smile are Happier than Those Who Frown.", 
      "People who Frown are Happier than Those Who Smile, Who Would Have Thunk It!")
  end

  def self.compare_two_values_and_return_string(category1, category2, string1, string2)
    unless category1.empty? || category2.empty?
      avg1 = category1.reduce(:+) / category1.count
      avg2 = category2.reduce(:+) / category2.count
      if avg1 > avg2
        return string1
      else
        return string2
      end
    end
  end

end
