class WordAnalysis

  def initialize(happiness_log, user, category =
    ['positive', 'negative', 'activity', 'culture', 'health', 'location', 'passion', 
     'relationship', 'satisfaction', 'self_view', 'spirituality', 'wealth'])
    @happiness_log = happiness_log
    @user = user
    @category = category
  end

  def word_analysis(category)
    datafile = Rails.root + "lib/data/#{category}.txt"
    keywords = File.readlines(datafile).map(&:strip)
    value = 0
    @happiness_log.main_post.gsub(/[^a-z '-+]/i, '').split(' ').each do |word| 
      if keywords.include?(word.downcase)
         value += 1 
      end
    end

    @happiness_log[category] = value
  end

  def convert_scale_by_deviation(category)
    squared_sum = 0.0
    sum = 0.0
    count = 0.0
    @happiness_log.save
    values = @user.happiness_logs.pluck(category)

    values.each do | integer |
        squared_sum += integer ** 2
        sum += integer
        count += 1
    end

    variance = squared_sum / count
    standard_deviation = Math.sqrt(variance)
    average = sum / count

    # def one_to_ten_scale(average)
    case
    when average == 0
      5
    when @happiness_log[category] <= (average - (3 * standard_deviation))
      0
    when @happiness_log[category] <= (average - (1.35 * standard_deviation))
      1
    when @happiness_log[category] <= (average - (0.85 * standard_deviation))
      2
    when @happiness_log[category] <= (average - (0.56 * standard_deviation))
      3
    when @happiness_log[category] <= (average - (0.3 * standard_deviation))
      4
    when @happiness_log[category] <= (average + (0.3 * standard_deviation))
      5
    when @happiness_log[category] >= (average + (3 * standard_deviation))
      10
    when @happiness_log[category] >= (average + (1.35 * standard_deviation))
      9
    when @happiness_log[category] >= (average + (0.85 * standard_deviation))
      8
    when @happiness_log[category] >= (average + (0.56 * standard_deviation))
      7  
    else
      6
    end
  end

  def count_and_scale
    @category.each do |category| 
      word_analysis(category)
      @happiness_log["#{category}_scale"] = convert_scale_by_deviation(category)
    end
  end

end
