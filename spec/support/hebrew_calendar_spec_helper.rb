module Zmanim
  module HebrewCalendarSpecHelper
    SECULAR_DATES = {
        modern: '2017-10-26',
        pre_gregorian: '1550-10-01',
        bce: '-0100-05-05'
    }

    ABSOLUTE_DATES = {
        modern: 736628,
        pre_gregorian: 566044,
        bce: -36741
    }

    JEWISH_DATES = {
        modern: '5778-08-06',
        pre_gregorian: '5311-07-11',
        bce: '3660-02-19'
    }

    def expect_gregorian_date(actual, *expected)
      expected = %i(year month day).map(&expected.first.method(:send)) if expected.first.respond_to?(:year)
      expect([actual.gregorian_year, actual.gregorian_month, actual.gregorian_day]).to eq expected
    end

    def expect_jewish_date(actual, *expected)
      expect([actual.jewish_year, actual.jewish_month, actual.jewish_day]).to eq expected
    end

    def expect_date_mappings(subject, gregorian, jewish)
      actual_gregorian = [subject.gregorian_year, subject.gregorian_month, subject.gregorian_day]
      actual_jewish = [subject.jewish_year, subject.jewish_month, subject.jewish_day]
      actual = [actual_gregorian, actual_jewish].map{|d| format_as_iso8601(*d)}
      expect(actual).to eq [gregorian, jewish]
    end

    def offset_days(date_string, offset)
      if date_string[0] == '-'
        negative = true
        date_string = date_string[1..-1]
      end
      year, month, day = date_string.split('-').map(&:to_i)
      year = -year if negative
      format_as_iso8601(year, month, day + offset)
    end

    def format_as_iso8601(year, month, day)
      "#{("%0+5i" % year).delete('+')}-#{"%02i" % month}-#{"%02i" % day}"
    end

    def days_matching(collection, days)
      collection.select{|k,v| days.include?(k)}
    end

    def all_days_matching(year, matcher, in_israel: false, use_modern_holidays: false)
      calendar = Zmanim::HebrewCalendar::JewishCalendar.new(year, 7, 1)
      calendar.in_israel = in_israel
      calendar.use_modern_holidays = use_modern_holidays
      (1..calendar.days_in_jewish_year).each_with_object({}) do |day_offset, m|
        if sd = matcher.call(calendar)
          m[sd] ||= []
          m[sd] << "#{calendar.jewish_month}-#{calendar.jewish_day}"
        end
        calendar.forward!
      end
    end
  end
end
