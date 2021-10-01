require "csv"

class Messages
  include Analyzer

  def initialize
    @input = CSV.read("./input/messages.csv", :headers => true)
    @nonrelevant_words = normalize_words(DICTIONARY.dig("messages", "unimportant_words"))
    @relevant_words = normalize_words(DICTIONARY.dig("messages", "job_related"))
  end

  def word_frequencies
    full_text = @input.map { |row| row["CONTENT"] }.compact.join(" ")
    normalize_words(full_text.split(/\s+/))
      .map { |w| w.gsub(/[^a-z]+/, "") }
      .reject { |w| w.size < 3 || @nonrelevant_words.include?(w) }
      .group_count.sort_by{ |a| a[1] }.reverse
  end

  def job_messages_per_month
    job_related_messages = @input.select { |row| row["CONTENT"] =~ /#{@relevant_words.join("|")}/i }
    metric_per_month(job_related_messages) { |row| Time.parse(row["DATE"]).to_date }
  end

  def word_cloud(words_limit = 100)
    cloud = MagicCloud::Cloud.new(word_frequencies.take(words_limit), rotate: :free)
    img = cloud.draw(960, 600) #default height/width
    img.write("./output/word_cloud.png")
  end
end
