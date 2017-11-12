require_relative 'astronomical_calculations'
require_relative 'math_helper'

module Zmanim::Util
  class SunTimesCalculator
    include AstronomicalCalculations
    using Zmanim::Util::MathHelper

    def name
      'US Naval Almanac Algorithm'
    end

    def utc_sunrise(date, geo_location, zenith, adjust_for_elevation: false)
      utc_sun_position(date, geo_location, zenith, adjust_for_elevation, :sunrise)
    rescue Math::DomainError
      nil
    end

    def utc_sunset(date, geo_location, zenith, adjust_for_elevation: false)
      utc_sun_position(date, geo_location, zenith, adjust_for_elevation, :sunset)
    rescue Math::DomainError
      nil
    end

    private

    DEG_PER_HOUR = 360.0 / 24.0

    def sin_deg(deg)
      Math.sin(deg.to_radians)
    end

    def cos_deg(deg)
      Math.cos(deg.to_radians)
    end

    def tan_deg(deg)
      Math.tan(deg.to_radians)
    end

    def acos_deg(x)
      Math.acos(x).to_degrees
    end

    def asin_deg(x)
      Math.asin(x).to_degrees
    end

    def atan_deg(x)
      Math.atan(x).to_degrees
    end

    def utc_sun_position(date, geo_location, zenith, adjust_for_elevation, mode)
      elevation = adjust_for_elevation ? geo_location.elevation : 0
      adjusted_zenith = adjusted_zenith(zenith, elevation)
      utc_time = calculate_utc_sun_position(date,
                                            geo_location.latitude,
                                            geo_location.longitude,
                                            adjusted_zenith,
                                            mode) # in hours
      utc_time % 24    # normalized (0...24)
    end

    def calculate_utc_sun_position(date, latitude, longitude, zenith, mode)
      day_of_year = date.yday
      hours_offset = hours_from_meridian(longitude)
      time_days = approx_time_days(day_of_year, hours_offset, mode)

      mean_anomaly = sun_mean_anomaly(time_days)
      true_long = sun_true_longitude(mean_anomaly)
      right_ascension_hours = sun_right_ascension_hours(true_long)
      cos_local_hour_angle = cos_local_hour_angle(true_long, latitude, zenith)

      local_hour_angle = acos_deg(cos_local_hour_angle)
      local_hour_angle = 360.0 - local_hour_angle if mode == :sunrise

      local_hour = local_hour_angle / DEG_PER_HOUR

      mean_time = local_mean_time(local_hour, right_ascension_hours, time_days)
      mean_time - hours_offset
    end

    def local_mean_time(local_hour, right_ascension_hours, time_days)
      local_hour + right_ascension_hours - (0.06571 * time_days) - 6.622
    end

    def cos_local_hour_angle(sun_true_long, latitude, zenith)
      sin_dec = 0.39782 * sin_deg(sun_true_long)
      cos_dec = cos_deg(asin_deg(sin_dec))
      (cos_deg(zenith) - (sin_dec * sin_deg(latitude))) / (cos_dec * cos_deg(latitude))
    end

    def sun_right_ascension_hours(sun_true_long)
      ra = atan_deg(0.91764 * tan_deg(sun_true_long))
      l_quadrant = (sun_true_long / 90.0).floor * 90.0
      ra_quadrant = (ra / 90.0).floor * 90.0
      ra += (l_quadrant - ra_quadrant)

      ra / DEG_PER_HOUR    # in hours
    end

    def sun_true_longitude(sun_mean_anomaly)
      true_longitude = sun_mean_anomaly +
          (1.916 * sin_deg(sun_mean_anomaly)) +
          (0.02 * sin_deg(2 * sun_mean_anomaly)) +
          282.634
      true_longitude % 360
    end

    def sun_mean_anomaly(time_days)
      (0.9856 * time_days) - 3.289
    end

    def approx_time_days(day_of_year, hours_offset, mode)
      mode_offset = mode == :sunrise ? 6.0 : 18.0
      day_of_year + ((mode_offset - hours_offset) / 24)
    end

    def hours_from_meridian(longitude)
      longitude / DEG_PER_HOUR
    end
  end
end
