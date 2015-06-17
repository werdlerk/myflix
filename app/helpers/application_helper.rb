module ApplicationHelper

  def rating_options
    (1..5).map { |i| [ pluralize(i, 'Star'), i] }.reverse
  end
end
