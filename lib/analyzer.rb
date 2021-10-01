module Analyzer
  DICTIONARY = YAML.load_file("./lib/dictionary.yaml")

  def metric_per_month(list, &block)
    # Date.strptime(row[date_label]).to_date
    grouped = list.map { |row| yield(row) }.group_count.to_h

    metrics_per_month = []

    dates = grouped.keys.sort
    date = dates.first.beginning_of_month
    while date < dates.last.beginning_of_month
      count = grouped.sum { |d, count| d > date && d < date + 1.month ? count : 0 }
      metrics_per_month << [date, count]
      date += 1.month
    end

    metrics_per_month
  end

  def normalize_words(list)
    list.map { |w| I18n.transliterate(w.downcase) }
  end
end
