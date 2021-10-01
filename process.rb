require "magic_cloud"
require "i18n"
require "byebug"
require "csv"
require "yaml"
require "awesome_print"
require 'active_support/core_ext/integer/time'
require 'active_support/core_ext/numeric/time'

require "./lib/mixin"
require "./lib/analyzer"
require "./lib/connections"
require "./lib/messages"

I18n.config.available_locales = :en

def save_csv(filename, input)
  CSV.open(filename, "w") do |csv|
    input.each { |row| csv << row }
  end
end

connections = Connections.new
messages = Messages.new

save_csv("./output/recruiters_per_month.csv", connections.recruiters_per_month)
save_csv("./output/job_messages_per_month.csv", messages.job_messages_per_month)
save_csv("./output/word_frequencies.csv", messages.word_frequencies)
messages.word_cloud
