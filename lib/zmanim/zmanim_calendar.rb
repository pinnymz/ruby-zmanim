module Zmanim
  class ZmanimCalendar < AstronomicalCalendar
    attr_accessor :candle_lighting_offset

    ZENITH_16_POINT_1 = GEOMETRIC_ZENITH + 16.1
    ZENITH_8_POINT_5 = GEOMETRIC_ZENITH + 8.5

    def initialize(opts)
      super
      @candle_lighting_offset = opts[:candle_lighting_offset] || 18
    end

    def tzais(opts={degrees: 8.5})
      degrees, offset = extract_degrees_offset(opts)
      offset_by_minutes(sunset_offset_by_degrees(GEOMETRIC_ZENITH + degrees), offset)
    end

    def tzais_72
      tzais(offset: 72)
    end

    def alos(opts={degrees: 16.1})
      degrees, offset = extract_degrees_offset(opts)
      offset_by_minutes(sunrise_offset_by_degrees(GEOMETRIC_ZENITH + degrees), offset)
    end

    def alos_72
      alos(offset: -72)
    end

    alias_method :chatzos, :sun_transit

    def sof_zman_shma(day_start, day_end)
      shaos_into_day(day_start, day_end, 3)
    end

    def sof_zman_shma_gra
      sof_zman_shma(sea_level_sunrise, sea_level_sunset)
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
      sof_zman_tfila(sea_level_sunrise, sea_level_sunset)
    end

    def sof_zman_tfila_mga
      sof_zman_tfila(alos_72, tzais_72)
    end

    def mincha_gedola(day_start=sea_level_sunrise, day_end=sea_level_sunset)
      shaos_into_day(day_start, day_end, 6.5)
    end

    def mincha_ketana(day_start=sea_level_sunrise, day_end=sea_level_sunset)
      shaos_into_day(day_start, day_end, 9.5)
    end

    def plag_hamincha(day_start=sea_level_sunrise, day_end=sea_level_sunset)
      shaos_into_day(day_start, day_end, 10.75)
    end

    def shaah_zmanis(day_start, day_end)
      temporal_hour(day_start, day_end)
    end

    def shaah_zmanis_gra
      shaah_zmanis(sea_level_sunrise, sea_level_sunset)
    end

    def shaah_zmanis_mga
      shaah_zmanis(alos_72, tzais_72)
    end

    def shaah_zmanis_by_degrees_and_offset(degrees, offset)
      opts = {degrees: degrees, offset: offset}
      shaah_zmanis(alos(opts.merge(offset: -offset)), tzais(opts))
    end

    private

    def shaos_into_day(day_start, day_end, shaos)
      return unless shaah_zmanis = temporal_hour(day_start, day_end)
      offset_by_minutes(day_start, (shaah_zmanis / MINUTE_MILLIS) * shaos)
    end

    def extract_degrees_offset(opts)
      [opts[:degrees] || 0.0, opts[:offset] || 0]
    end

    def offset_by_minutes(time, minutes)
      return unless time
      time + (minutes / (60 * 24).to_f)
    end
  end
end