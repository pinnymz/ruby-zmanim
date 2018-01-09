module Zmanim::Limudim::Anchor
  class DayOfMonthAnchor
    attr_reader :day
    def initialize(day)
      @day = day
    end

    def next_occurrence(jewish_date)
      occurrence = Zmanim::HebrewCalendar::JewishDate.new(jewish_date.jewish_year, jewish_date.jewish_month, day)
      increment_month(occurrence) if occurrence <= jewish_date
      occurrence
    end

    def previous_occurrence(jewish_date)
      occurrence = Zmanim::HebrewCalendar::JewishDate.new(jewish_date.jewish_year, jewish_date.jewish_month, day)
      decrement_month(occurrence) if occurrence >= jewish_date
      occurrence
    end

    def current_or_previous_occurrence(jewish_date)
      occurrence = Zmanim::HebrewCalendar::JewishDate.new(jewish_date.jewish_year, jewish_date.jewish_month, day)
      decrement_month(occurrence) if occurrence > jewish_date
      occurrence
    end

    private

    def increment_month(jewish_date)
      if jewish_date.jewish_month == jewish_date.months_in_jewish_year
        jewish_date.jewish_month = 1
      elsif jewish_date.jewish_month == 6
        jewish_date.forward!(29)
      else
        jewish_date.jewish_month += 1
      end
    end

    def decrement_month(jewish_date)
      if jewish_date.jewish_month == 1
        jewish_date.jewish_month = jewish_date.months_in_jewish_year
      elsif jewish_date.jewish_month == 7
        back_days = jewish_date.jewish_day == 30 ? 30 : 29
        jewish_date.back!(back_days)
      else
        jewish_date.jewish_month -= 1
      end
    end
  end
end
