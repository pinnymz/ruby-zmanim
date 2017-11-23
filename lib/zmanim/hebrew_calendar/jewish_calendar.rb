require_relative 'jewish_date'

module Zmanim::HebrewCalendar
  class JewishCalendar < JewishDate
    attr_accessor :in_israel, :use_modern_holidays

    def initialize(*args)
      if args.count == 4
        super(args[0..2])
        @in_israel = !!args[3]
      else
        super
      end
    end

    def significant_day
      @yom_tov = send("#{jewish_month_name}_significant_day")
    end

    def yom_tov?
      sd = significant_day
      sd && !sd.to_s.start_with?('erev_') && (!taanis? || sd == :yom_kippur)
    end

    def yom_tov_assur_bemelacha?
      %i(pesach shavuos rosh_hashana yom_kippur succos shemini_atzeres simchas_torah).include?(significant_day)
    end

    def chol_hamoed?
      sd = significant_day
      sd && (sd.to_s.start_with?('chol_hamoed_') || sd == :hoshana_rabbah)
    end

    def erev_yom_tov?
      return false unless sd = significant_day
      sd.to_s.start_with?('erev_') || sd == :hoshana_rabbah ||
          (sd == :chol_hamoed_pesach && jewish_day == 20)
    end

    def taanis?
      %i(seventeen_of_tammuz tisha_beav tzom_gedalyah yom_kippur tenth_of_teves taanis_esther).include?(significant_day)
    end

    def rosh_chodesh?
      jewish_day == 30 || (jewish_day == 1 && jewish_month != 7)
    end

    def erev_rosh_chodesh?
      jewish_day == 29 && jewish_month != 6
    end

    def chanukah?
      significant_day == :chanukah
    end

    def day_of_chanukah
      return unless chanukah?
      if jewish_month_name == :kislev
        jewish_day - 24
      else
        (kislev_short? ? 5 : 6) + jewish_day
      end
    end

    def day_of_omer
      case jewish_month_name
        when :nissan
          return (jewish_day - 15 if jewish_day > 15)
        when :iyar
          return jewish_day + 15
        when :sivan
          return (jewish_day + 44) if jewish_day < 6
      end
    end

    # DateTime for molad as UTC
    def molad_as_datetime
      m = molad
      location_name = 'Jerusalem, Israel'
      latitude = 31.778   # Har Habayis latitude
      longitude = 35.2354 # Har Habayis longitude
      tz = TZInfo::Timezone.get('Asia/Jerusalem')

      geo = Zmanim::Util::GeoLocation.new(location_name, latitude, longitude, tz)
      seconds = (m.molad_chalakim * 10) / 3.0
      # molad as local mean time
      time = DateTime.new(m.gregorian_year, m.gregorian_month, m.gregorian_day,
                          m.molad_hours, m.molad_minutes, seconds, '+2')
      offset_hours = geo.local_mean_time_offset / Zmanim::AstronomicalCalendar::HOUR_MILLIS.to_f
      # molad as Jerusalem standard time
      time -= offset_hours / 24.0
      # molad as UTC
      time.new_offset(0)
    end

    def techilas_zman_kiddush_levana_3_days
      molad_as_datetime + 3
    end

    def techilas_zman_kiddush_levana_7_days
      molad_as_datetime + 7
    end

    def sof_zman_kiddush_levana_between_moldos
      half_molad_in_days = CHALAKIM_PER_MONTH.to_f / (1080 * 24 * 2)
      molad_as_datetime + half_molad_in_days
    end

    def sof_zman_kiddush_levana_15_days
      molad_as_datetime + 15
    end
    
    # def daf_yomi_bavli
    #
    # end
    #
    # def daf_yomi_yerushalmi
    #
    # end

    private

    def nissan_significant_day
      pesach = [15, 21]
      pesach |= [16, 22] unless in_israel
      chol_hamoed_pesach = (16..20)
      if jewish_day == 14
        :erev_pesach
      elsif pesach.include? jewish_day
        :pesach
      elsif chol_hamoed_pesach.include? jewish_day
        :chol_hamoed_pesach
      elsif use_modern_holidays
        if (jewish_day == 26 && day_of_week == 5) ||
           (jewish_day == 27 && ![1,6].include?(day_of_week)) ||
           (jewish_day == 28 && day_of_week == 2)
          :yom_hashoah
        end
      end
    end

    def iyar_significant_day
      if jewish_day == 14
        :pesach_sheni
      elsif use_modern_holidays
        # Note that this logic follows the current rules, which were last revised in 5764.
        # The calculations for years prior may not reflect the actual dates observed at that time.
        if ([2,3].include?(jewish_day) && day_of_week == 4) ||
           (jewish_day == 4 && day_of_week == 3) ||
           (jewish_day == 5 && day_of_week == 2)
          :yom_hazikaron
        elsif ([3,4].include?(jewish_day) && day_of_week == 5) ||
              (jewish_day == 5 && day_of_week == 4) ||
              (jewish_day == 6 && day_of_week == 3)
          :yom_haatzmaut
        elsif jewish_day == 28
          :yom_yerushalayim
        end
      end
    end

    def sivan_significant_day
      shavuos = [6]
      shavuos << 7 unless in_israel
      if jewish_day == 5
        :erev_shavuos
      elsif shavuos.include?(jewish_day)
        :shavuos
      end
    end

    def tammuz_significant_day
      if (jewish_day == 17 && day_of_week != 7) ||
         (jewish_day == 18 && day_of_week == 1)
        :seventeen_of_tammuz
      end
    end

    def av_significant_day
      if (jewish_day == 9 && day_of_week != 7) ||
         (jewish_day == 10 && day_of_week == 1)
        :tisha_beav
      elsif jewish_day == 15
        :tu_beav
      end
    end

    def elul_significant_day
      if jewish_day == 29
        :erev_rosh_hashana
      end
    end

    def tishrei_significant_day
      succos = [15]
      succos << 16 unless in_israel
      chol_hamoed_succos = (16..20)
      if [1,2].include? jewish_day
        :rosh_hashana
      elsif (jewish_day == 3 && day_of_week != 7) ||
            (jewish_day == 4 && day_of_week == 1)
        :tzom_gedalyah
      elsif jewish_day == 9
        :erev_yom_kippur
      elsif jewish_day == 10
        :yom_kippur
      elsif jewish_day == 14
        :erev_succos
      elsif succos.include?(jewish_day)
        :succos
      elsif chol_hamoed_succos.include?(jewish_day)
        :chol_hamoed_succos
      elsif jewish_day == 21
        :hoshana_rabbah
      elsif jewish_day == 22
        :shemini_atzeres
      elsif jewish_day == 23 && !in_israel
        :simchas_torah
      end
    end

    def cheshvan_significant_day
      nil
    end

    def kislev_significant_day
      if jewish_day >= 25
        :chanukah
      end
    end

    def teves_significant_day
      chanukah = [1,2]
      chanukah << 3 if kislev_short?
      if chanukah.include?(jewish_day)
        :chanukah
      elsif jewish_day == 10
        :tenth_of_teves
      end
    end

    def shevat_significant_day
      if jewish_day == 15
        :tu_beshvat
      end
    end

    def adar_significant_day
      if jewish_leap_year?
        if jewish_day == 14
          :purim_katan
        elsif jewish_day == 15
          :shushan_purim_katan
        end
      else
        purim_significant_day
      end
    end

    def adar_ii_significant_day
      purim_significant_day
    end

    def purim_significant_day
      if (jewish_day == 13 && day_of_week != 7) ||
          (jewish_day == 11 && day_of_week == 5)
        :taanis_esther
      elsif jewish_day == 14
        :purim
      elsif jewish_day == 15
        :shushan_purim
      end
    end
  end
end
