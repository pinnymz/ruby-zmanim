module Zmanim
  module AstroCalendarSpecHelper
    # locations
    LAKEWOOD = Zmanim::Util::GeoLocation.new('Lakewood, NJ', 40.0721087,-74.2400243, 'US/Eastern', elevation: 15)
    JERUSALEM = Zmanim::Util::GeoLocation.new('Jerusalem, Israel', 31.7781161,35.233804, 'Asia/Jerusalem', elevation: 740)
    LOS_ANGELES = Zmanim::Util::GeoLocation.new('Los Angeles, CA', 34.0201613,-118.6919095, 'US/Pacific', elevation: 71)
    TOKYO = Zmanim::Util::GeoLocation.new('Tokyo, Japan', 35.6733227,139.6403486, 'Asia/Tokyo', elevation: 40 )
    ARCTIC_NUNAVUT = Zmanim::Util::GeoLocation.new('Fort Conger, NU Canada', 81.7449398,-64.7945858, 'Canada/Eastern', elevation: 127)
    SAMOA = Zmanim::Util::GeoLocation.new('Apia, Samoa', -13.8599098,-171.8031745, 'Pacific/Apia', elevation: 1858)

    # edge-case locations
    HOOPER_BAY = Zmanim::Util::GeoLocation.new('Hooper Bay, Alaska', 61.520182,-166.1740437, 'US/Alaska', elevation: 8)
    DANEBORG = Zmanim::Util::GeoLocation.new('Daneborg, Greenland', 74.2999996,-20.2420877, 'America/Godthab', elevation: 0)

    # test date
    BASIC_DATE = Date.parse('2017-10-17')

    # groups
    TEST_LOCATIONS = [LAKEWOOD, JERUSALEM, LOS_ANGELES, TOKYO, ARCTIC_NUNAVUT, SAMOA]

    def expect_time_to_match(method, expected)
      results = TEST_LOCATIONS.map do |geo|
        subject = astro_calendar_for(BASIC_DATE, geo)
        time = method.call(subject)
        time&.round(8)
      end
      expect(results).to eq expected
    end

    def expect_datetime_to_match(method, expected)
      results = TEST_LOCATIONS.map do |geo|
        subject = astro_calendar_for(BASIC_DATE, geo)
        time = method.call(subject)
        time&.to_s
      end
      expect(results).to eq expected
    end

    def astro_calendar_for(date, geo)
      subject = Zmanim::AstronomicalCalendar.new
      subject.geo_location = geo
      subject.date = date
      subject
    end
  end
end
