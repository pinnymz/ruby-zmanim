require_relative 'astronomical_calendar'

module Zmanim
  class ZmanimCalendar < AstronomicalCalendar
    attr_accessor :candle_lighting_offset
    attr_writer :use_elevation

    ZENITH_16_POINT_1 = GEOMETRIC_ZENITH + 16.1
    ZENITH_8_POINT_5 = GEOMETRIC_ZENITH + 8.5

    def initialize(opts={})
      super
      @candle_lighting_offset = opts[:candle_lighting_offset] || 18
      @use_elevation = false
    end

    def use_elevation?
      !!@use_elevation
    end

    def sunrise
      use_elevation? ? super : sea_level_sunrise
    end

    def sunset
      use_elevation? ? super : sea_level_sunset
    end

    def tzais(opts={degrees: 8.5})
      degrees, offset, zmanis_offset = extract_degrees_offset(opts)
      sunset_for_degrees = degrees == 0 ? sunset : sunset_offset_by_degrees(GEOMETRIC_ZENITH + degrees)
      if zmanis_offset != 0
        offset_by_minutes_zmanis(sunset_for_degrees, zmanis_offset)
      else
        offset_by_minutes(sunset_for_degrees, offset)
      end
    end

    def tzais_72
      tzais(offset: 72)
    end

    def alos(opts={degrees: 16.1})
      degrees, offset, zmanis_offset = extract_degrees_offset(opts)
      sunrise_for_degrees = degrees == 0 ? sunrise : sunrise_offset_by_degrees(GEOMETRIC_ZENITH + degrees)
      if zmanis_offset != 0
        offset_by_minutes_zmanis(sunrise_for_degrees, -zmanis_offset)
      else
        offset_by_minutes(sunrise_for_degrees, -offset)
      end
    end

    def alos_72
      alos(offset: 72)
    end

    alias_method :chatzos, :sun_transit

    def sof_zman_shma(day_start, day_end)
      shaos_into_day(day_start, day_end, 3)
    end

    def sof_zman_shma_gra
      sof_zman_shma(sunrise, sunset)
    end

    def sof_zman_shma_mga
      sof_zman_shma(alos_72, tzais_72)
    end

    def candle_lighting
      offset_by_minutes(sea_level_sunset , -candle_lighting_offset)
    end

    def sof_zman_tfila(day_start, day_end)
      shaos_into_day(day_start, day_end, 4)
    end

    def sof_zman_tfila_gra
      sof_zman_tfila(sunrise, sunset)
    end

    def sof_zman_tfila_mga
      sof_zman_tfila(alos_72, tzais_72)
    end

    def mincha_gedola(day_start=sunrise, day_end=sunset)
      shaos_into_day(day_start, day_end, 6.5)
    end

    def mincha_ketana(day_start=sunrise, day_end=sunset)
      shaos_into_day(day_start, day_end, 9.5)
    end

    def plag_hamincha(day_start=sunrise, day_end=sunset)
      shaos_into_day(day_start, day_end, 10.75)
    end

    def shaah_zmanis(day_start, day_end)
      temporal_hour(day_start, day_end)
    end

    def shaah_zmanis_gra
      shaah_zmanis(sunrise, sunset)
    end

    def shaah_zmanis_mga
      shaah_zmanis(alos_72, tzais_72)
    end

    def shaah_zmanis_by_degrees_and_offset(degrees, offset)
      opts = {degrees: degrees, offset: offset}
      shaah_zmanis(alos(opts), tzais(opts))
    end

    private

    def shaos_into_day(day_start, day_end, shaos)
      return unless shaah_zmanis = temporal_hour(day_start, day_end)
      offset_by_minutes(day_start, (shaah_zmanis / MINUTE_MILLIS) * shaos)
    end

    def extract_degrees_offset(opts)
      [opts[:degrees] || 0.0, opts[:offset] || 0, opts[:zmanis_offset] || 0]
    end

    def offset_by_minutes(time, minutes)
      return unless time
      time + (minutes / (60 * 24).to_f)
    end

    def offset_by_minutes_zmanis(time, minutes)
      return unless time
      shaah_zmanis_skew = shaah_zmanis(sunrise, sunset) / HOUR_MILLIS
      time + (minutes * shaah_zmanis_skew / (60 * 24).to_f)
    end
  end
end
