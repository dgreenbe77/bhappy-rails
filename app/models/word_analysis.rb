class WordAnalysis

  def initialize(happiness_log, user, category =
    ['positive', 'negative', 'activity', 'culture', 'health', 'location', 'passion', 
     'relationship', 'satisfaction', 'self_view', 'spirituality', 'wealth'])
    @happiness_log = happiness_log
    @user = user
    @category = category
  end

  def word_analysis(category)
    unigram_file = Rails.root + "lib/data/#{category}.txt"
    bigram_file = Rails.root + "lib/data/#{category}_bigrams.txt"
    unigrams = File.readlines(unigram_file).map(&:strip)
    bigrams = File.readlines(bigram_file).map(&:strip)
    value = 0
    main_post_words = @happiness_log.main_post.gsub(/[^a-z '-+]/i, '').split(' ')

    main_post_words.each do |word| 
      if unigrams.include?(word.downcase)
         value += 1 
      end
    end

    main_post_words.each_index do |index| 
      unless main_post_words[index + 1].blank?
        if bigrams.include?(main_post_words[index] + ' ' + main_post_words[index + 1])
          value += 1 
        end
      end
    end

    @happiness_log[category] = value
  end

  def convert_scale_by_deviation(category)
    squared_sum = 0.0
    sum = 0.0
    count = 0.0
    @happiness_log.save
    values = @user.happiness_logs.pluck(category).delete_if {|integer| integer.nil? }

    values.each do | integer |
      squared_sum += integer ** 2
      sum += integer
      count += 1
    end

    variance = squared_sum / count
    standard_deviation = Math.sqrt(variance)
    average = sum / count

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

  def self.create_bi_grams(second_words, front = true, categories =
    ['positive', 'negative', 'activity', 'culture', 'health', 'location', 'passion', 
     'relationship', 'satisfaction', 'self_view', 'spirituality', 'wealth'])
    categories.each do |category|
      bigram_file = Rails.root + "lib/data/#{category}_bigrams.txt"
      File.open(bigram_file, 'a') do |file|
        unigrams = Rails.root + "lib/data/#{category}.txt"
        keywords = File.readlines(unigrams).map(&:strip)
        keywords.each do |word|
          second_words.each do |word2|
            if front
              file << (word2 + " " + word + "\n")
            else
              file << (word + " " + word2 + "\n")
            end
          end
        end
      end
    end
  end

  def learning(category)
    unigram_file = Rails.root + "lib/data/#{category}_learning.txt"
    main_post_words = @happiness_log.main_post.gsub(/[^a-z '-+]/i, '').split(' ')
    File.open(unigram_file, 'a') do |file|
      main_post_words.each do |word|
        file << word + "\n"
      end
    end
  end

end
