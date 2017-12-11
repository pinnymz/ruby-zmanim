module Zmanim::Util
  class GeoLocation
    attr_reader   :elevation,
                  :latitude,
                  :location_name,
                  :longitude,
                  :time_zone

    def initialize(name, latitude, longitude, time_zone, elevation:nil)
      self.location_name = name
      self.latitude = latitude
      self.longitude = longitude
      self.time_zone = time_zone
      self.elevation = elevation
    end

    def self.GMT
      new('Greenwich, England', 51.4772, 0, 'GMT')
    end

    def latitude=(args)
      if args.respond_to?(:size) && args.size == 4
        degrees, minutes, seconds, direction = *args
        temp = degrees + ((minutes + (seconds / 60.0)) / 60.0)
        raise ArgumentError unless %w{S N}.include? direction
        raise ArgumentError unless temp >= 0
        temp *= -1 if direction == 'S'
        self.latitude = temp
      else
        raise ArgumentError unless (-90..90).include?(args)
        @latitude = args
      end
    end

    def longitude=(args)
      if args.respond_to?(:size) && args.size == 4
        degrees, minutes, seconds, direction = *args
        temp = degrees + ((minutes + (seconds / 60.0)) / 60.0)
        raise ArgumentError unless %w{W E}.include? direction
        raise ArgumentError unless temp >= 0
        temp *= -1 if direction == 'W'
        self.longitude = temp
      else
        raise ArgumentError unless (-180..180).include?(args)
        @longitude = args
      end
    end

    def elevation=(e)
      e ||= 0
      raise ArgumentError unless e >= 0
      @elevation = e
    end

    def location_name=(name)
      @location_name = name
    end

    def time_zone=(tz)
      tz = TZInfo::Timezone.get(tz) if tz.is_a?(String)
      raise ArgumentError unless tz.is_a?(TZInfo::Timezone)
      @time_zone = tz
    end

    # Number of Days to adjust due to antimeridian crossover
    #
    # The actual Time Zone offset may deviate from the expected offset based on the longitude
    # But since the 'absolute time' calculations are always based on longitudinal offset from UTC
    # for a given date, the date is presumed to only increase East of the Prime Meridian, and to
    # only decrease West of it.
    # For Time Zones that cross the antimeridian, the date will be artificially adjusted before calculation
    # to conform with this presumption.
    #
    # For example, Samoa (located around 172W) uses a local offset of +14:00.  When asking to calculate for
    # 2017-03-15, the calculator should operate using 2017-03-14 since the expected zone is -11.  After
    # determining the UTC time, the local offset of +14:00 should be applied to bring the date back to 2017-03-15.
    def antimeridian_adjustment
      expected_time_zone = expected_meridian_offset / Zmanim::AstronomicalCalendar::HOUR_MILLIS.to_f
      local_time_zone = standard_time_offset / Zmanim::AstronomicalCalendar::HOUR_MILLIS.to_f
      if expected_time_zone >= 10 && local_time_zone <= -10
        1
      elsif expected_time_zone <= -10 && local_time_zone >= 10
        -1
      else
        0
      end
    end

    # Time Zone offset as expected based on the local meridian (in ms).
    #
    # Essentially, this returns what the Standard Time offset would be
    # if Time Zone boundaries would be drawn consistently on 15° meridians.
    def expected_meridian_offset
      Zmanim::AstronomicalCalendar::HOUR_MILLIS * ((longitude + 7.5).floor / 15)  # truncate on 15
    end

    # Local Mean Time offset for the expected time zone (in ms).
    #
    # The offset is the difference between Local Mean Time at the given
    # longitude and Standard Time in effect for the given time zone.
    def local_mean_time_offset
      (longitude * 4 * Zmanim::AstronomicalCalendar::MINUTE_MILLIS) - standard_time_offset
    end

    # Standard Time offset from UTC based on the provided Time Zone (in ms).
    #
    # This will ignore DST transformations.
    def standard_time_offset
      time_zone.current_period.utc_offset * 1000
    end

    # Time Zone offset from UTC at a given point in time (in ms).
    #
    # This will take into account any DST transformation in effect
    # for the given Time Zone at the given time
    def time_zone_offset_at(utc_time)
      time_zone.period_for_utc(utc_time).utc_total_offset * 1000
    end

    def clone
      self.class.new(location_name.dup, latitude, longitude, time_zone.dup, elevation: elevation)
    end

  end
end
