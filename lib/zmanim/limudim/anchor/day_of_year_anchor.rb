module Zmanim::Limudim::Anchor
  class DayOfYearAnchor
    attr_reader :month, :day
    def initialize(month, day)
      @month = month
      @day = day
    end

    def next_occurrence(jewish_date)
      occurrence = Zmanim::HebrewCalendar::JewishDate.new(jewish_date.jewish_year, month, day)
      occurrence.jewish_year += 1 if occurrence <= jewish_date
      occurrence
    end

    def previous_occurrence(jewish_date)
      occurrence = Zmanim::HebrewCalendar::JewishDate.new(jewish_date.jewish_year, month, day)
      occurrence.jewish_year -= 1 if occurrence >= jewish_date
      occurrence
    end

    def current_or_previous_occurrence(jewish_date)
      occurrence = Zmanim::HebrewCalendar::JewishDate.new(jewish_date.jewish_year, month, day)
      occurrence.jewish_year -= 1 if occurrence > jewish_date
      occurrence
    end
  end
end
