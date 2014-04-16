class Demographic

  def self.compare_age_ranges(min, max, min2, max2)
    age_range1 = HappinessLog.where("min_age >= #{min} AND max_age <= #{max}").pluck(:happy_scale).delete_if { |int| int.nil? }
    age_range2 = HappinessLog.where("min_age >= #{min2} AND max_age <= #{max2}").pluck(:happy_scale).delete_if { |int| int.nil? }

    unless age_range1.empty? || age_range2.empty?
      age_range1_avg = age_range1.reduce(:+) / age_range1.count
      age_range2_avg = age_range2.reduce(:+) / age_range2.count
      if age_range1_avg > age_range2_avg
        return "People Between Ages #{min} and #{max} are Happier \n than People Between Ages #{min2} and #{max2}"
      else
        return "People Between Ages #{min2} and #{max2} are Happier \n than People Between Ages #{min} and #{max}"
      end
    end
  end

  def self.compare_genders
    male = HappinessLog.where("gender = 'Male' AND gender_confidence >= 60").pluck(:happy_scale).delete_if { |int| int.nil? }
    female = HappinessLog.where("gender = 'Female' AND gender_confidence >= 60").pluck(:happy_scale).delete_if { |int| int.nil? }

    unless male.empty? || female.empty?
      male_avg = male.reduce(:+) / male.count
      female_avg = female.reduce(:+) / female.count
      if male_avg > female_avg
        return "Males are Happier than Females"
      else
        return "Females are Happier than Males"
      end
    end
  end

  def self.compare_smiles
    smiling = HappinessLog.where("smile >= 50").pluck(:happy_scale).delete_if { |int| int.nil? }
    frowning = HappinessLog.where("smile <= 50").pluck(:happy_scale).delete_if { |int| int.nil? }

    unless smiling.empty? || frowning.empty?
      smiling_avg = smiling.reduce(:+) / smiling.count
      frowning_avg = frowning.reduce(:+) / frowning.count
      if smiling_avg > frowning_avg
        return "People who Smile are Happier than Those Who Frown"
      else
        return "People who Frown are Happier than Those Who Smile, Who Would Have Thunk It!"
      end
    end
  end

end
