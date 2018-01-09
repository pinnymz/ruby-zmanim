module Zmanim::Limudim::Anchor
  class DayOfWeekAnchor
    attr_reader :day_of_week
    def initialize(day_of_week)
      @day_of_week = day_of_week
    end

    def next_occurrence(date)
      offset = day_of_week - date.day_of_week
      offset += 7 if offset <= 0
      date + offset
    end

    def previous_occurrence(date)
      offset = day_of_week - date.day_of_week
      offset -= 7 if offset >= 0
      date + offset
    end

    def current_or_previous_occurrence(date)
      offset = day_of_week - date.day_of_week
      offset -= 7 if offset > 0
      date + offset
    end
  end
end
