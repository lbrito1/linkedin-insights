require "csv"

class Connections
  include Analyzer

  def initialize
    @input = CSV.read("./input/connections.csv", :headers => true)
    @recruiter_titles = DICTIONARY.dig("connections", "recruiter_titles")
  end

  def recruiters_per_month
    recruiters = @input.select { |row| row["Position"] =~ /#{@recruiter_titles.join("|")}/i }
    metric_per_month(recruiters) { |row| Date.parse(row["Connected On"]).to_date }
  end
end
