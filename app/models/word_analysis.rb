class WordAnalysis < ActiveRecord::Base

  def self.init(info, user, category =
    ['positive', 'negative', 'activity', 'culture', 'health', 'location', 'passion', 
     'relationship', 'satisfaction', 'self_view', 'spirituality', 'wealth'])
    @info = info
    @user = user
    @category = category
  end

  def self.word_analysis(category)
    datafile = Rails.root + "lib/data/#{category}.txt"
    keywords = File.readlines(datafile).map(&:strip)
    value = 0

    @info.main_post.gsub(/[^a-z '-+]/i, '').split(' ').each do |word| 
      if keywords.include?(word.downcase)
         value += 1 
      end
    end

    @info[category] = value
  end

  def self.convert_scale_by_deviation(category)
    squared_sum = 0.0
    sum = 0.0
    count = 0.0
    @info.save
    values = @user.infos.pluck(category)

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
    when @info[category] <= (average - (3 * standard_deviation))
      0
    when @info[category] <= (average - (1.35 * standard_deviation))
      1
    when @info[category] <= (average - (0.85 * standard_deviation))
      2
    when @info[category] <= (average - (0.56 * standard_deviation))
      3
    when @info[category] <= (average - (0.3 * standard_deviation))
      4
    when @info[category] <= (average + (0.3 * standard_deviation))
      5
    when @info[category] >= (average + (3 * standard_deviation))
      10
    when @info[category] >= (average + (1.35 * standard_deviation))
      9
    when @info[category] >= (average + (0.85 * standard_deviation))
      8
    when @info[category] >= (average + (0.56 * standard_deviation))
      7  
    else
      6
    end
  end

  def self.count_and_scale
    @category.each do |category| 
      WordAnalysis.word_analysis(category)
      @info["#{category}_scale"] = WordAnalysis.convert_scale_by_deviation(category)
    end
  end

end
