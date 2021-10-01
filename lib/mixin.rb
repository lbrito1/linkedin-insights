module Enumerable
  def group_count(&block)
    group_by(&(block || :itself)).map { |k, v| [k, v.size] }.sort_by(&:last)
  end
end
