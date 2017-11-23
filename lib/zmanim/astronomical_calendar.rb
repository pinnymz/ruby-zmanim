module Zmanim
  class AstronomicalCalendar
    attr_accessor :geo_location,
                  :astronomical_calculator,
                  :date

    GEOMETRIC_ZENITH = 90
    CIVIL_ZENITH = 96
    NAUTICAL_ZENITH = 102
    ASTRONOMICAL_ZENITH = 108

    MINUTE_MILLIS = 60 * 1000
    HOUR_MILLIS = MINUTE_MILLIS * 60

    def initialize(opts={})
      @geo_location = opts[:geo_location] || Util::GeoLocation.GMT
      @date = opts[:date] || Date.today
      @astronomical_calculator = opts[:calculator] || Util::NOAACalculator.new
    end

    def sunrise
      date_time_from_time_of_day utc_sunrise(GEOMETRIC_ZENITH), :sunrise
    end

    def sea_level_sunrise
      sunrise_offset_by_degrees(GEOMETRIC_ZENITH)
    end

    def sunrise_offset_by_degrees(offset_zenith)
      date_time_from_time_of_day utc_sea_level_sunrise(offset_zenith), :sunrise
    end

    def sunset
      date_time_from_time_of_day utc_sunset(GEOMETRIC_ZENITH), :sunset
    end

    def sea_level_sunset
      sunset_offset_by_degrees(GEOMETRIC_ZENITH)
    end

    def sunset_offset_by_degrees(offset_zenith)
      date_time_from_time_of_day utc_sea_level_sunset(offset_zenith), :sunset
    end

    def utc_sunrise(zenith)
      astronomical_calculator.utc_sunrise(adjusted_date, geo_location, zenith, adjust_for_elevation: true)
    end

    def utc_sunset(zenith)
      astronomical_calculator.utc_sunset(adjusted_date, geo_location, zenith, adjust_for_elevation: true)
    end

    def utc_sea_level_sunrise(zenith)
      astronomical_calculator.utc_sunrise(adjusted_date, geo_location, zenith, adjust_for_elevation: false)
    end

    def utc_sea_level_sunset(zenith)
      astronomical_calculator.utc_sunset(adjusted_date, geo_location, zenith, adjust_for_elevation: false)
    end

    def temporal_hour(sunrise=sea_level_sunrise, sunset=sea_level_sunset)
      return unless sunset && sunrise
      daytime_hours = ((sunset - sunrise) * 24).to_f
      (daytime_hours / 12) * HOUR_MILLIS
    end

    def sun_transit
      sunrise = sea_level_sunrise
      sunset = sea_level_sunset
      return unless sunrise && sunset
      noon_hour = (temporal_hour(sunrise, sunset) / HOUR_MILLIS) * 6.0
      sunrise + (noon_hour / 24.0)
    end

    private

    def adjusted_date
      date + geo_location.antimeridian_adjustment
    end

    # returns DateTime adjusted for the provided Time Zone
    def date_time_from_time_of_day(time_of_day, mode)
      return unless time_of_day
      hours, remainder = (time_of_day * 3600).divmod 3600
      minutes, seconds = remainder.divmod 60
      year, month, day = %i(year month day).map(&adjusted_date.method(:send))
      utc_time = DateTime.new(year, month, day, hours, minutes, seconds, '0')

      # adjust date if utc time reflects a wraparound from the local offset
      meridian_offset = geo_location.local_meridian_offset / HOUR_MILLIS
      if hours + meridian_offset > 18 && mode == :sunrise      # sunrise after 6pm indicates the UTC date has occurred earlier
        utc_time -= 1
      elsif hours + meridian_offset < 6 && mode == :sunset     # sunset before 6am indicates the UTC date has occurred later
        utc_time += 1
      end

      convert_date_time_for_zone utc_time
    end

    def convert_date_time_for_zone(time)
      converter = Util::TimeZoneConverter.new(geo_location.time_zone)
      converter.modify_offset(time)
    end
  end
end
