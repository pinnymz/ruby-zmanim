require_relative 'astronomical_calculations'
require_relative 'math_helper'

module Zmanim::Util
  class NOAACalculator
    include AstronomicalCalculations
    using Zmanim::Util::MathHelper

    JULIAN_DAY_JAN_1_2000 = 2451545.0
    JULIAN_DAYS_PER_CENTURY = 36525.0

    def name
      'US National Oceanic and Atmospheric Administration Algorithm'
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

    def julian_centuries_from_julian_day(julian_day)
      (julian_day - JULIAN_DAY_JAN_1_2000) / JULIAN_DAYS_PER_CENTURY
    end

    def julian_day_from_julian_centuries(julian_centuries)
      (julian_centuries * JULIAN_DAYS_PER_CENTURY) + JULIAN_DAY_JAN_1_2000
    end

    def utc_sun_position(date, geo_location, zenith, adjust_for_elevation, mode)
      elevation = adjust_for_elevation ? geo_location.elevation : 0.0
      adjusted_zenith = adjusted_zenith(zenith, elevation)
      utc_time = calculate_utc_sun_position(date.ajd,
                                            geo_location.latitude,
                                            -geo_location.longitude,
                                            adjusted_zenith,
                                             mode) # in minutes
      utc_time /= 60.0   # in hours
      utc_time % 24      # normalized (0...24)
    end

    def calculate_utc_sun_position(julian_day, latitude, longitude, zenith, mode)
      julian_centuries = julian_centuries_from_julian_day(julian_day)

      # first pass using solar noon
      noonmin = solar_noon_utc(julian_centuries, longitude)
      tnoon = julian_centuries_from_julian_day(julian_day + (noonmin / 1440.0))
      first_pass = approximate_utc_sun_position(tnoon, latitude, longitude, zenith, mode)

      # refine using output of first pass
      trefinement = julian_centuries_from_julian_day(julian_day + (first_pass / 1440.0))
      approximate_utc_sun_position(trefinement, latitude, longitude, zenith, mode)
    end

    def approximate_utc_sun_position(approx_julian_centuries, latitude, longitude, zenith, mode)
      eq_time = equation_of_time(approx_julian_centuries)
      solar_dec = solar_declination(approx_julian_centuries)
      hour_angle = sun_hour_angle_at_horizon(latitude, solar_dec, zenith, mode)

      delta = longitude - hour_angle.to_degrees
      time_delta = delta * 4.0
      720 + time_delta - eq_time
    end

    def sun_hour_angle_at_horizon(latitude, solar_dec, zenith, mode)
      lat_r = latitude.to_radians
      solar_dec_r = solar_dec.to_radians
      zenith_r = zenith.to_radians

      hour_angle = Math.acos(
          (Math.cos(zenith_r) / (Math.cos(lat_r) * Math.cos(solar_dec_r))) -
              (Math.tan(lat_r) * Math.tan(solar_dec_r))
      )

      hour_angle *= -1 if mode == :sunset
      hour_angle # in radians
    end

    def solar_declination(julian_centuries)
      correction = obliquity_correction(julian_centuries).to_radians
      lambda = sun_apparent_longitude(julian_centuries).to_radians
      sint = Math.sin(correction) * Math.sin(lambda)
      Math.asin(sint).to_degrees    # in degrees
    end

    def sun_apparent_longitude(julian_centuries)
      true_longitude = sun_true_longitude(julian_centuries)
      omega = 125.04 - (1934.136 * julian_centuries)
      true_longitude - 0.00569 - (0.00478 * Math.sin(omega.to_radians))  # in degrees
    end

    def sun_true_longitude(julian_centuries)
      sgml = sun_geometric_mean_longitude(julian_centuries)
      center = sun_equation_of_center(julian_centuries)
      sgml + center       # in degrees
    end

    def sun_equation_of_center(julian_centuries)
      mrad = sun_geometric_mean_anomaly(julian_centuries).to_radians
      sinm = Math.sin(mrad)
      sin2m = Math.sin(2 * mrad)
      sin3m = Math.sin(3 * mrad)

      (sinm * (1.914602 - (julian_centuries * (0.004817 + (0.000014 * julian_centuries))))) +
      (sin2m * (0.019993 - (0.000101 * julian_centuries))) +
      (sin3m * 0.000289)  # in degrees
    end

    def solar_noon_utc(julian_centuries, longitude)
      century_start = julian_day_from_julian_centuries(julian_centuries)

      # first pass to yield approximate solar noon
      approx_tnoon = julian_centuries_from_julian_day(century_start + (longitude / 360.0))
      approx_eq_time = equation_of_time(approx_tnoon)
      approx_sol_noon = 720 + (longitude * 4) - approx_eq_time

      # refinement using output of first pass
      tnoon = julian_centuries_from_julian_day(century_start - 0.5 + (approx_sol_noon / 1440.0))
      eq_time = equation_of_time(tnoon)
      720 + (longitude * 4) - eq_time
    end

    def equation_of_time(julian_centuries)
      epsilon = obliquity_correction(julian_centuries).to_radians
      sgml = sun_geometric_mean_longitude(julian_centuries).to_radians
      sgma = sun_geometric_mean_anomaly(julian_centuries).to_radians
      eoe = earth_orbit_eccentricity(julian_centuries)

      y = Math.tan(epsilon / 2.0)
      y *= y

      sin2l0 = Math.sin(2.0 * sgml)
      sin4l0 = Math.sin(4.0 * sgml)
      cos2l0 = Math.cos(2.0 * sgml)
      sinm = Math.sin(sgma)
      sin2m = Math.sin( 2.0 * sgma)

      eq_time = (y * sin2l0) - (2.0 * eoe * sinm) + (4.0 * eoe * y * sinm * cos2l0) - (0.5 * y * y * sin4l0) - (1.25 * eoe * eoe * sin2m)
      eq_time.to_degrees * 4.0  # minutes of time
    end


    def earth_orbit_eccentricity(julian_centuries)
      0.016708634 - (julian_centuries * (0.000042037 + (0.0000001267 * julian_centuries)))  # unitless
    end

    def sun_geometric_mean_anomaly(julian_centuries)
      anomaly = 357.52911 + (julian_centuries * (35999.05029 - (0.0001537 * julian_centuries)))   # in degrees

      anomaly % 360         # normalized (0...360)
    end

    def sun_geometric_mean_longitude(julian_centuries)
      longitude = 280.46646 + (julian_centuries * (36000.76983 + (0.0003032 * julian_centuries)))  # in degrees

      longitude % 360       # normalized (0...360)
    end

    def obliquity_correction(julian_centuries)
      obliquity_of_ecliptic = mean_obliquity_of_ecliptic(julian_centuries)

      omega = 125.04 - (1934.136 * julian_centuries)
      correction = obliquity_of_ecliptic + (0.00256 * Math.cos(omega.to_radians))
      correction % 360     # normalized (0...360)
    end

    def mean_obliquity_of_ecliptic(julian_centuries)
      seconds = 21.448 - (julian_centuries * (46.8150 + (julian_centuries * (0.00059 - (julian_centuries * 0.001813)))))
      23.0 + ((26.0 + (seconds / 60)) / 60.0)  # in degrees
    end
  end
end
