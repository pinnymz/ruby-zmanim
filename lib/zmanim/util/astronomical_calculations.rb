require_relative 'math_helper'

module Zmanim::Util
  module AstronomicalCalculations
    using Zmanim::Util::MathHelper

    GEOMETRIC_ZENITH = 90.0

    attr_writer :earth_radius,
                :refraction,
                :solar_radius

    def refraction
      @refraction ||= 34 / 60.0
    end

    def solar_radius
      @solar_radius ||= 16 / 60.0
    end

    def earth_radius
      @earth_radius ||= 6356.9  # km
    end

    def elevation_adjustment(elevation)
      Math.acos(earth_radius / (earth_radius + (elevation / 1000.0))).to_degrees
    end

    def adjusted_zenith(zenith, elevation)
      return zenith unless zenith == GEOMETRIC_ZENITH  #only adjust for exact sunrise or sunset
      zenith + solar_radius + refraction + elevation_adjustment(elevation)
    end
  end
end
